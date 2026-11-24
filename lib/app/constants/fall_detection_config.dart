class FallDetectionConfig {
  final double lowerThreshold;
  final double impactThreshold;
  final double gyroThreshold;
  final double inactivityThreshold;
  final int inactivityObservationMs;
  final int confirmationCountdownSeconds;
  final int smoothingWindowSize;

  const FallDetectionConfig({
    this.lowerThreshold = 6.0,
    this.impactThreshold = 22.0,
    this.gyroThreshold = 3.5,
    this.inactivityThreshold = 3.0,
    this.inactivityObservationMs = 2500,
    this.confirmationCountdownSeconds = 30,
    this.smoothingWindowSize = 5,
  });

  static const FallDetectionConfig standard = FallDetectionConfig();

  static const FallDetectionConfig sensitive = FallDetectionConfig(
    lowerThreshold: 6.5,
    impactThreshold: 18.0,
    gyroThreshold: 3.0,
    inactivityThreshold: 3.5,
    inactivityObservationMs: 2000,
    confirmationCountdownSeconds: 20,
    smoothingWindowSize: 3,
  );

  static const FallDetectionConfig strict = FallDetectionConfig(
    lowerThreshold: 5.0,
    impactThreshold: 26.0,
    gyroThreshold: 4.5,
    inactivityThreshold: 2.5,
    inactivityObservationMs: 3000,
    confirmationCountdownSeconds: 30,
    smoothingWindowSize: 7,
  );
}
