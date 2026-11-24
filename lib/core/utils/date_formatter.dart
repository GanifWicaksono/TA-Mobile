import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(dateTime)} WIB';
  }

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    try {
      return formatter.format(dateTime);
    } catch (_) {
      return DateFormat('d MMM yyyy').format(dateTime);
    }
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)}, ${formatTime(dateTime)}';
  }

  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin, ${formatTime(dateTime)}';
    } else {
      return formatDate(dateTime);
    }
  }
}
