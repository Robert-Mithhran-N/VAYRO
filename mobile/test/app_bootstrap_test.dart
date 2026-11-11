import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vayro/app/app.dart';
import 'package:vayro/core/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VAYRO Application Bootstrap Tests', () {
    testWidgets('App root initializes without throwing exceptions', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: VayroApp(),
        ),
      );

      // Verify splash screen branding renders immediately
      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(find.text(AppConstants.appTagline), findsOneWidget);
    });
  });
}

