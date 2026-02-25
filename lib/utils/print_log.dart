import 'package:flutter/foundation.dart';

class Print {
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _reset = '\x1B[0m';

  static void normalLog(String message) {
    if (!kDebugMode) return;
    debugPrint(message);
  }

  static void debugLog(String message) {
    if (!kDebugMode) return;
    const int chunkSize = 800;
    if (message.length <= chunkSize) {
      debugPrint(message);
    } else {
      // Split into chunks and print each one
      final pattern = RegExp('.{1,$chunkSize}');
      pattern.allMatches(message).forEach((match) {
        debugPrint(match.group(0)!);
      });
    }
  }

  static void greenLog(String message) {
    if (!kDebugMode) return;
    const int chunkSize = 800;
    if (message.length <= chunkSize) {
      debugPrint('$_green$message$_reset');
    } else {
      // Split into chunks and print each one
      final pattern = RegExp('.{1,$chunkSize}');
      pattern.allMatches(message).forEach((match) {
        debugPrint('$_green${match.group(0)!}$_reset');
      });
    }
  }

  static void errorLog(String message) {
    if (!kDebugMode) return;
    const int chunkSize = 800;
    if (message.length <= chunkSize) {
      debugPrint('$_red$message$_reset');
    } else {
      // Split into chunks and print each one
      final pattern = RegExp('.{1,$chunkSize}');
      pattern.allMatches(message).forEach((match) {
        debugPrint('$_red${match.group(0)!}$_reset');
      });
    }
  }
}
