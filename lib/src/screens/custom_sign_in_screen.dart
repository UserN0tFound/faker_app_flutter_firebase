import 'package:faker_app_flutter_firebase/src/screens/ui_auth_providers.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ajout de widget pour la connexion via firebase_ui_auth
    // pleins de choses déjà préconfigurées
    final authProviders = ref.watch(AuthProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: SignInScreen(
        providers: authProviders,
      ),
    );
  }
}
