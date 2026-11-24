import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../app/constants/fall_detection_config.dart';
import '../utils/sensor_math.dart';

enum FallDetectionState {
  idle,
  monitoring,
  possibleFall,
  confirmation,
  emergencyTriggered,
  cancelled,
}

class FallTelemetry {
  final double currentAcceleration;
  final double peakImpactAcceleration;
  final double gyroMagnitude;
  final double tiltAngle;
  final double inactivityVariance;
  final DateTime timestamp;

  const FallTelemetry({
    required this.currentAcceleration,
    required this.peakImpactAcceleration,
    required this.gyroMagnitude,
    required this.tiltAngle,
    required this.inactivityVariance,
    required this.timestamp,
  });
}

class FallDetectionService extends ChangeNotifier {
  FallDetectionConfig config;

  FallDetectionState _state = FallDetectionState.idle;
  FallDetectionState get state => _state;

  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;

  final List<double> _accelBuffer = [];
  final List<double> _postImpactBuffer = [];

  double _latestAx = 0.0;
  double _latestAy = 0.0;
  double _latestAz = 9.8;
  double _latestGx = 0.0;
  double _latestGy = 0.0;
  double _latestGz = 0.0;

  double _currentResultant = 9.8;
  double _peakImpact = 0.0;
  double _preImpactTilt = 0.0;
  bool _freeFallDetected = false;
  DateTime? _freeFallTimestamp;
  DateTime? _impactTimestamp;
  Timer? _inactivityTimer;
  DateTime? _lastTriggerTime;

  VoidCallback? onPossibleFallDetected;

  FallDetectionService({this.config = FallDetectionConfig.standard});

  double get currentAcceleration => _currentResultant;
  double get peakImpact => _peakImpact;
  double get currentTiltAngle =>
      SensorMath.calculateTiltAngleDegrees(_latestAx, _latestAy, _latestAz);

  void startMonitoring() {
    if (_state == FallDetectionState.monitoring) return;

    _resetDetectionBuffers();
    _state = FallDetectionState.monitoring;
    notifyListeners();

    try {
      _accelSubscription = accelerometerEventStream().listen(
        _handleAccelerometerSample,
        onError: (err) {
          debugPrint('Accelerometer stream error: $err');
        },
      );

      _gyroSubscription = gyroscopeEventStream().listen(
        _handleGyroscopeSample,
        onError: (err) {
          debugPrint('Gyroscope stream error: $err');
        },
      );
    } catch (e) {
      debugPrint('Sensor hardware listener initialization failed: $e');
    }
  }

  void stopMonitoring() {
    _accelSubscription?.cancel();
    _accelSubscription = null;
    _gyroSubscription?.cancel();
    _gyroSubscription = null;

    _inactivityTimer?.cancel();
    _inactivityTimer = null;

    _resetDetectionBuffers();
    _state = FallDetectionState.idle;
    notifyListeners();
  }

  void _resetDetectionBuffers() {
    _accelBuffer.clear();
    _postImpactBuffer.clear();
    _freeFallDetected = false;
    _freeFallTimestamp = null;
    _impactTimestamp = null;
    _peakImpact = 0.0;
  }

  void _handleGyroscopeSample(GyroscopeEvent event) {
    _latestGx = event.x;
    _latestGy = event.y;
    _latestGz = event.z;
  }

  void _handleAccelerometerSample(AccelerometerEvent event) {
    processSensorData(
      event.x,
      event.y,
      event.z,
      _latestGx,
      _latestGy,
      _latestGz,
    );
  }

  void processSensorData(
    double ax,
    double ay,
    double az,
    double gx,
    double gy,
    double gz,
  ) {
    if (_state != FallDetectionState.monitoring) return;

    _latestAx = ax;
    _latestAy = ay;
    _latestAz = az;
    _latestGx = gx;
    _latestGy = gy;
    _latestGz = gz;

    final rawMagnitude = SensorMath.calculateResultant(ax, ay, az);

    _accelBuffer.add(rawMagnitude);
    if (_accelBuffer.length > config.smoothingWindowSize) {
      _accelBuffer.removeAt(0);
    }
    _currentResultant = SensorMath.movingAverage(_accelBuffer);

    final now = DateTime.now();

    // 10-second debounce to prevent duplicate alarms for the same event
    if (_lastTriggerTime != null &&
        now.difference(_lastTriggerTime!).inSeconds < 10) {
      return;
    }

    // Phase 1: Free-fall detection (weightlessness drop)
    if (_currentResultant < config.lowerThreshold) {
      _freeFallDetected = true;
      _freeFallTimestamp = now;
      _preImpactTilt = SensorMath.calculateTiltAngleDegrees(ax, ay, az);
    }

    // Phase 2: High-g impact detection within 800ms window
    if (_currentResultant > config.impactThreshold) {
      final isNearFreeFall = _freeFallDetected &&
          _freeFallTimestamp != null &&
          now.difference(_freeFallTimestamp!).inMilliseconds < 800;

      final gyroMag = SensorMath.calculateResultant(gx, gy, gz);
      final hasRotation = gyroMag > config.gyroThreshold;

      if (isNearFreeFall || hasRotation || _currentResultant > (config.impactThreshold * 1.25)) {
        _impactTimestamp = now;
        _peakImpact = _currentResultant;
        _startInactivityObservation();
      }
    }

    // Phase 3: Post-impact inactivity observation window
    if (_impactTimestamp != null && _inactivityTimer != null) {
      _postImpactBuffer.add(_currentResultant);
    }

    notifyListeners();
  }

  void _startInactivityObservation() {
    _inactivityTimer?.cancel();
    _postImpactBuffer.clear();

    _inactivityTimer = Timer(
      Duration(milliseconds: config.inactivityObservationMs),
      _evaluatePostImpactInactivity,
    );
  }

  void _evaluatePostImpactInactivity() {
    if (_state != FallDetectionState.monitoring) return;

    final postImpactTilt = SensorMath.calculateTiltAngleDegrees(
      _latestAx,
      _latestAy,
      _latestAz,
    );
    final tiltDelta = (postImpactTilt - _preImpactTilt).abs();

    final variance = SensorMath.calculateVariance(_postImpactBuffer);

    // If movement variance is low (user is motionless on ground) and tilt shifted
    final isMotionless = variance < config.inactivityThreshold;
    final hasOrientationShift = tiltDelta > 30.0 || _peakImpact > (config.impactThreshold * 1.3);

    if (isMotionless || hasOrientationShift) {
      _triggerPossibleFall();
    } else {
      _resetDetectionBuffers();
    }
  }

  void _triggerPossibleFall() {
    _lastTriggerTime = DateTime.now();
    _state = FallDetectionState.possibleFall;
    notifyListeners();

    onPossibleFallDetected?.call();
  }

  void simulateFallEvent() {
    _state = FallDetectionState.possibleFall;
    _peakImpact = 28.4;
    _lastTriggerTime = DateTime.now();
    notifyListeners();

    onPossibleFallDetected?.call();
  }

  void enterConfirmation() {
    _state = FallDetectionState.confirmation;
    notifyListeners();
  }

  void confirmSafe() {
    _state = FallDetectionState.cancelled;
    _resetDetectionBuffers();
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 300), () {
      _state = FallDetectionState.monitoring;
      notifyListeners();
    });
  }

  void confirmEmergency() {
    _state = FallDetectionState.emergencyTriggered;
    _resetDetectionBuffers();
    notifyListeners();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
