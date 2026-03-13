import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les 4 champs requis
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          // Navigation vers l'accueil en nettoyant la pile de navigation
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? "Erreur d'inscription"),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Créer un compte",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // Nom complet
                CustomTextField(
                  label: "Nom complet",
                  controller: _nameController,
                  hint: "Entrez votre nom",
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Le nom est requis";
                    if (value.length < 2) return "Minimum 2 caractères";
                    return null;
                  },
                ),

                // Email
                CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  hint: "votre.email@isikm.sn",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "L'email est requis";
                    if (!value.contains('@') || !value.contains('.')) {
                      return "Format d'email invalide";
                    }
                    return null;
                  },
                ),

                // Mot de passe
                CustomTextField(
                  label: "Mot de passe",
                  controller: _passwordController,
                  hint: "••••••",
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Requis";
                    if (value.length < 6) return "Minimum 6 caractères";
                    return null;
                  },
                ),

                // Confirmation (La logique de validation croisée)
                CustomTextField(
                  label: "Confirmer le mot de passe",
                  controller: _confirmPasswordController,
                  hint: "••••••",
                  prefixIcon: Icons.lock_reset,
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                CustomButton(
                  text: "S'inscrire",
                  isLoading: authProvider.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Déjà un compte ? Se connecter"),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}