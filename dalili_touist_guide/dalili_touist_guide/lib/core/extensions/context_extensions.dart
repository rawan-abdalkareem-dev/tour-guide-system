import 'package:flutter/widgets.dart';

import '../../gen_l10n/app_localizations.dart';

extension Localization on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;

  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  double get topPadding => MediaQuery.paddingOf(this).top;
}
