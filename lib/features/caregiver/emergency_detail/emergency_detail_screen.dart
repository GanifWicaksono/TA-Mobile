import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/emergency_event_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/carelink_app_bar.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/providers/app_state_provider.dart';

class EmergencyDetailScreen extends StatefulWidget {
  final EmergencyEvent event;

  const EmergencyDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<EmergencyDetailScreen> createState() => _EmergencyDetailScreenState();
}

class _EmergencyDetailScreenState extends State<EmergencyDetailScreen> {
  late EmergencyEvent _currentEvent;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Memulai panggilan ke $phone...')),
      );
    }
  }

  Future<void> _openNavigationMap(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membuka koordinat: $lat, $lng')),
      );
    }
  }

  void _showMarkHandledDialog() {
    _notesController.text = 'Sudah dihubungi dan dipastikan kondisi aman.';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Tandai Sudah Ditangani',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan catatan penanganan kejadian ini untuk arsip keluarga:',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFE4EDF6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.safeMintDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final state = Provider.of<AppStateProvider>(context, listen: false);
              await state.markEventHandled(
                eventId: _currentEvent.eventId,
                handledNotes: _notesController.text.trim(),
              );
              setState(() {
                _currentEvent = _currentEvent.copyWith(
                  eventStatus: EmergencyEventStatus.handled,
                  handledAt: DateTime.now(),
                  handledNotes: _notesController.text.trim(),
                );
              });
              if (!mounted) return;
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kejadian berhasil ditandai sebagai sudah ditangani.'),
                  backgroundColor: AppColors.safeMintDark,
                ),
              );
            },
            child: const Text('Simpan & Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final elderlyPhone = state.primaryConnectedElderly.phone;

    BadgeType badgeType;
    switch (_currentEvent.eventStatus) {
      case EmergencyEventStatus.handled:
        badgeType = BadgeType.safe;
        break;
      case EmergencyEventStatus.received:
      case EmergencyEventStatus.pending:
      case EmergencyEventStatus.sent:
        badgeType = BadgeType.emergency;
        break;
      case EmergencyEventStatus.cancelled:
        badgeType = BadgeType.neutral;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CareLinkAppBar(
        title: 'Detail Kejadian',
        subtitle: _currentEvent.eventId,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _currentEvent.eventType == EmergencyEventType.possibleFall
                                  ? const Color(0xFFFFECEC)
                                  : const Color(0xFFEAF2FD),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _currentEvent.eventType == EmergencyEventType.possibleFall
                                  ? Icons.accessibility_new_rounded
                                  : Icons.sos_rounded,
                              color: _currentEvent.eventType == EmergencyEventType.possibleFall
                                  ? AppColors.emergencyCoral
                                  : AppColors.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentEvent.eventType.displayName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                _currentEvent.userName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      StatusBadge(
                        label: _currentEvent.eventStatus.displayName,
                        type: badgeType,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Waktu Terdeteksi',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormatter.formatDateTime(_currentEvent.timestamp),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (_currentEvent.handledAt != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Waktu Penanganan',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormatter.formatDateTime(_currentEvent.handledAt!),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.safeMintDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_currentEvent.handledNotes != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EEF8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        'Catatan: ${_currentEvent.handledNotes!}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Lokasi Terdeteksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_currentEvent.locationAvailable && _currentEvent.latitude != null) ...[
                    Text(
                      _currentEvent.address ?? 'Koordinat Terbaca',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${_currentEvent.latitude!.toStringAsFixed(5)}, Lng: ${_currentEvent.longitude!.toStringAsFixed(5)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFD6E3F2),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(double.infinity, 160),
                            painter: _SimpleMapGridPainter(),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.emergencyCoral,
                                  shape: BoxShape.circle,
                                  boxShadow: AppColors.emergencyGlow,
                                ),
                                child: const Icon(
                                  Icons.person_pin_circle_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _currentEvent.userName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.location_off_rounded, color: AppColors.textMuted, size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Lokasi GPS tidak tersedia saat kejadian dilaporkan.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: NeumorphicButton(
                    onPressed: () => _makePhoneCall(elderlyPhone),
                    variant: ButtonVariant.primary,
                    height: 56,
                    icon: Icons.phone_in_talk_rounded,
                    child: const Text(
                      'Hubungi Lansia',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                if (_currentEvent.locationAvailable && _currentEvent.latitude != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () => _openNavigationMap(
                        _currentEvent.latitude!,
                        _currentEvent.longitude!,
                      ),
                      variant: ButtonVariant.secondary,
                      height: 56,
                      icon: Icons.navigation_rounded,
                      child: const Text(
                        'Buka Navigasi',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),

            if (_currentEvent.eventStatus != EmergencyEventStatus.handled &&
                _currentEvent.eventStatus != EmergencyEventStatus.cancelled)
              NeumorphicButton(
                onPressed: _showMarkHandledDialog,
                variant: ButtonVariant.safe,
                height: 56,
                isFullWidth: true,
                icon: Icons.check_circle_outline_rounded,
                child: const Text(
                  'TANDAI SUDAH DITANGANI',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SimpleMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 3;

    final roadPaint = Paint()
      ..color = const Color(0xFFC7D8EB)
      ..strokeWidth = 14;

    // Draw grid roads
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), linePaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), linePaint);

    final dotPaint = Paint()
      ..color = const Color(0xFFABC5E3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.25), 18, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.75), 24, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
