import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vayro/app/theme/app_colors.dart';
import 'package:vayro/app/theme/app_theme.dart';
import 'package:vayro/shared/widgets/vayro_button.dart';
import 'package:vayro/shared/widgets/vayro_card.dart';
import 'package:vayro/shared/widgets/vayro_loading_indicator.dart';
import 'package:vayro/shared/widgets/vayro_status_badge.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('VAYRO Shared Widget Rendering Tests', () {
    testWidgets('VayroButton renders text and triggers onPressed callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          VayroButton(
            text: 'Test Action',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      );

      expect(find.text('Test Action'), findsOneWidget);
      await tester.tap(find.text('Test Action'));
      expect(tapped, isTrue);
    });

    testWidgets('VayroCard renders child content properly', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const VayroCard(
            child: Text('Card Content'),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('VayroStatusBadge displays label and status correctly', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const VayroStatusBadge(
            label: 'ONLINE',
            level: VayroStatusLevel.success,
          ),
        ),
      );

      expect(find.text('ONLINE'), findsOneWidget);
    });

    testWidgets('VayroLoadingIndicator renders message and spinner', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const VayroLoadingIndicator(
            message: 'Loading test...',
          ),
        ),
      );

      expect(find.text('Loading test...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

