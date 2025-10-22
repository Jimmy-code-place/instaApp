import 'package:flutter/material.dart';
import 'package:social_app_frontend/core/localization/app_localization.dart';

import 'package:social_app_frontend/core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('profile'))),
      body: Container(
        decoration: AppTheme.gradientDecoration(),
        child: Center(
          child: Text(
            l10n.translate('profile'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
