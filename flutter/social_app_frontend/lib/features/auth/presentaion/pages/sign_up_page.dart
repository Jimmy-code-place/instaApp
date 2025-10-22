import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app_frontend/core/localization/app_localization.dart';
import 'package:social_app_frontend/core/theme/app_theme.dart';
import 'package:social_app_frontend/features/auth/presentaion/providers/auth_provider.dart';
import 'package:social_app_frontend/features/post/presentaion/pages/posts_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('sign_up'))),
      body: Container(
        decoration: AppTheme.gradientDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.translate('name')),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: l10n.translate('email')),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: l10n.translate('password'),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final success = await ref
                      .read(authProvider.notifier)
                      .register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                  if (success && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PostsPage(isGuest: false),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.translate('signup_failed'))),
                    );
                  }
                },
                child: Text(l10n.translate('sign_up')),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PostsPage(isGuest: true),
                  ),
                ),
                child: Text(l10n.translate('guest')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
