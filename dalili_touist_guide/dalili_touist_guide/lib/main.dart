import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/storage/preferences_service.dart';
import 'core/storage/sqlite_service.dart';
import 'gen_l10n/app_localizations.dart';
import 'providres/booking_provider.dart';
import 'providres/fanorites_providre.dart';
import 'providres/font_size_provider.dart';
import 'providres/locale_provider.dart';
import 'providres/navigation_provider.dart';
import 'providres/theme_provider.dart';
import 'providres/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage layers
  await PreferencesService.init();
  await SQLiteService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, FavoritesProvider>(
          create: (_) => FavoritesProvider(),
          update: (_, userProvider, favoritesProvider) {
            final uid = userProvider.userData?['uid'] ??
                PreferencesService.currentUserUid ??
                'guest';
            favoritesProvider?.updateUser(uid);
            return favoritesProvider ?? FavoritesProvider(initialUserId: uid);
          },
        ),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp.router(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) {
              final fontSizeProvider = context.watch<FontSizeProvider>();

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(fontSizeProvider.scaleFactor),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
