import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Pour générer l'ID unique lors de l'inscription
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  // Instance du service de stockage (Singleton)
  final StorageService _storageService = StorageService.instance;
  final _uuid = const Uuid();

  // Propriétés privées
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters publics
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null; // true si un utilisateur est connecté
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialisation : Charge l'utilisateur depuis le stockage au démarrage
  Future<void> init() async {
    _currentUser = _storageService.getCurrentUser();
    notifyListeners();
  }

  // LOGIQUE LOGIN (Respectant tes points 1 à 6)
  Future<bool> login(String email, String password) async {
    // 1. Début du chargement
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 2. Récupérer tous les utilisateurs
      final List<User> users = await _storageService.getUsers();

      // 3. Chercher l'utilisateur correspondant
      // On utilise firstWhere qui lance une erreur si rien n'est trouvé
      final user = users.firstWhere(
            (u) => u.email == email && u.password == password,
      );

      // 4. Si trouvé : sauvegarder
      _currentUser = user;
      await _storageService.saveCurrentUser(user);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // 5. Si non trouvé ou erreur
      _error = "Email ou mot de passe incorrect";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGIQUE REGISTER (Respectant tes points 1 à 4)
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<User> users = await _storageService.getUsers();

      // 1. Vérifier qu'aucun utilisateur n'existe déjà avec cet email
      if (users.any((u) => u.email == email)) {
        throw Exception("Cet email est déjà utilisé");
      }

      // 2. Créer un nouvel objet User avec un ID généré (UUID)
      final newUser = User(
        id: _uuid.v4(), // Génération de l'ID unique
        name: name,
        email: email,
        password: password,
        createdAt: DateTime.now(),
      );

      // 3. Sauvegarder via StorageService
      await _storageService.saveUser(newUser);

      // 4. Définir comme utilisateur courant
      _currentUser = newUser;
      await _storageService.saveCurrentUser(newUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    _currentUser = null;
    await _storageService.removeCurrentUser();
    notifyListeners();
  }

  // Mise à jour du profil
  Future<void> updateProfile({String? name, String? email}) async {
    if (_currentUser == null) return;

    // On utilise le copyWith du modèle User du prof
    final updatedUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
    );

    _currentUser = updatedUser;
    await _storageService.saveCurrentUser(updatedUser);
    // Note: Il faudrait aussi mettre à jour la liste globale des users ici
    notifyListeners();
  }

  // Efface le message d'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}