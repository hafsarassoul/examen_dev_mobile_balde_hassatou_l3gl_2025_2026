import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'register_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Clé globale pour valider le formulaire (Logique Prof)
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les saisies
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Méthode de connexion
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        // Navigation vers HomeScreen en vidant la pile (Logique Prof)
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
          );
        }
      } else {
        // Affichage de l'erreur via SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? "Identifiants incorrects"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.lock_person, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  "Bienvenue !",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Connectez-vous pour gérer vos projets",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 48),

                // Champ Email avec validation
                CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  hint: "exemple@isikm.sn",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "L'email est obligatoire";
                    if (!value.contains('@') || !value.contains('.')) {
                      return "Format d'email invalide";
                    }
                    return null;
                  },
                ),

                // Champ Mot de passe avec validation
                CustomTextField(
                  label: "Mot de passe",
                  controller: _passwordController,
                  hint: "••••••",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Mot de passe obligatoire";
                    if (value.length < 6) return "Minimum 6 caractères";
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Bouton de connexion avec état loading
                CustomButton(
                  text: "Se connecter",
                  isLoading: authProvider.isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 16),

                // Lien vers l'inscription
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Pas de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}