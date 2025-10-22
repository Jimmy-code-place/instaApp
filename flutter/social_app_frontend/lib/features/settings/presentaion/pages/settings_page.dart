import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_frontend/core/localization/app_localization.dart';

import 'package:social_app_frontend/core/theme/app_theme.dart';

import 'package:social_app_frontend/features/auth/presentaion/pages/sign_in_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('settings'))),
      body: Container(
        decoration: AppTheme.gradientDecoration(),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(l10n.translate('dark_mode')),
              value: ref.watch(themeModeProvider) == ThemeMode.dark,
              onChanged: (val) {
                ref.read(themeModeProvider.notifier).state = val
                    ? ThemeMode.dark
                    : ThemeMode.light;
              },
            ),
            ListTile(
              title: Text(l10n.translate('language')),
              trailing: DropdownButton<String>(
                value: Localizations.localeOf(context).languageCode,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                ],
                onChanged: (val) async {
                  if (val != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('locale', val);
                    // Restart app or update locale dynamically (restart required for simplicity)
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInPage()),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
