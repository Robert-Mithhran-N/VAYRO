import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logging/app_logger.dart';
import 'app.dart';

/// Bootstraps the VAYRO mobile application with safety guards and diagnostics.
Future<void> bootstrap() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      AppLogger.info('Initializing VAYRO Mobile Client Foundation...', 'Bootstrap');

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.error(
          'Flutter Framework Error: ${details.exceptionAsString()}',
          details.exception,
          details.stack,
          'FlutterError',
        );
      };

      runApp(
        const ProviderScope(
          child: VayroApp(),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.error(
        'Unhandled Zone Exception: $error',
        error,
        stackTrace,
        'ZonedGuarded',
      );
    },
  );
}

