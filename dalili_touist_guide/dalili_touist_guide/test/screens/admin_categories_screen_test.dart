import 'package:dalili_tourist_guide/gen_l10n/app_localizations.dart';
import 'package:dalili_tourist_guide/screens/admin/admin_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AdminCategoriesScreen renders category cards without overflow in Arabic (RTL) on narrow screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AdminCategoriesScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AdminCategoriesScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AdminCategoriesScreen renders category cards without overflow in English (LTR) on narrow screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AdminCategoriesScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AdminCategoriesScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
