import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_frontend/core/localization/app_localization.dart';
import 'package:social_app_frontend/core/theme/app_theme.dart';
import 'package:social_app_frontend/features/auth/presentaion/pages/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('auth');
  final prefs = await SharedPreferences.getInstance();
  final locale = prefs.getString('locale') ?? 'en';
  Intl.defaultLocale = locale;
  runApp(ProviderScope(child: MyApp(locale: Locale(locale))));
}

class MyApp extends ConsumerWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Mini Social App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: AppLocalizations.localeResolutionCallback,
      home: const SignInPage(),
    );
  }
}
