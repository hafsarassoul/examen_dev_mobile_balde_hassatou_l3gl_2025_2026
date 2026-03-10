import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/project.dart';
/**
 * Pattern Singleton:
 * Pour avoir une seule instance
 */
class StorageService {
  //===== Singleton ==========
  /// Instance Unique (privee)
  static StorageService? _instance;

  /// Getter pour acceder a l'instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Constructeur prive
  StorageService._();

  //===== SharedPreferences ==========
  /**
   * SharedPreferences utilise des opérations asynchrones
   * car il lit/ecrtit sur le disque
   *
   * Le mot-cle await attend que l'operation se termine
   * La fonction doit etre marque async et retourner un Future
   * Les variables doivent être marqué par late
   */
  late SharedPreferences _prefs;

  /// Indicateur d'initialisation
  bool _initialized = false;

  Future<void> init() async {
    if(_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ======== Cles de Stockage =========
  static const String _keyOnboardingConmplete = 'onboarding_complete';


  bool get isOnboardingComplete {
    return _prefs.getBool(_keyOnboardingConmplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_keyOnboardingConmplete, value);
  }

  // ======== Nouvelles Clés pour l'Authentification =========
  static const String _keyUsers = 'users_list';
  static const String _keyCurrentUser = 'current_user';

  // --- MÉTHODES POUR LES UTILISATEURS ---

  /// Récupère la liste de tous les utilisateurs inscrits
  Future<List<User>> getUsers() async {
    final String? usersJson = _prefs.getString(_keyUsers);
    if (usersJson == null) return [];

    // On décode le texte JSON en liste d'objets
    final List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((u) => User.fromMap(u)).toList();
  }

  /// Sauvegarde un nouvel utilisateur dans la liste globale
  Future<void> saveUser(User user) async {
    final users = await getUsers();
    users.add(user);
    // On transforme la liste d'objets en texte JSON pour le stockage
    await _prefs.setString(_keyUsers, jsonEncode(users.map((u) => u.toMap()).toList()));
  }

  // --- MÉTHODES POUR LA SESSION (CONNEXION) ---

  /// Sauvegarde l'utilisateur actuellement connecté
  Future<void> saveCurrentUser(User user) async {
    await _prefs.setString(_keyCurrentUser, jsonEncode(user.toMap()));
  }

  /// Récupère l'utilisateur de la session en cours
  User? getCurrentUser() {
    final String? userJson = _prefs.getString(_keyCurrentUser);
    if (userJson == null) return null;
    return User.fromMap(jsonDecode(userJson));
  }

  /// Supprime l'utilisateur de la session (Déconnexion)
  Future<void> removeCurrentUser() async {
    await _prefs.remove(_keyCurrentUser);
  }

  // ======== GESTION DES PROJETS (CRUD) =========
  static const String _keyProjects = 'projects_list';

  /// Récupère tous les projets stockés
  Future<List<Project>> getProjects() async {
    final String? data = _prefs.getString(_keyProjects);
    if (data == null) return [];

    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((p) => Project.fromMap(p)).toList();
  }

  /// Sauvegarde un nouveau projet
  Future<void> saveProject(Project project) async {
    final projects = await getProjects();
    projects.add(project);
    await _prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toMap()).toList()));
  }

  /// Met à jour un projet existant
  Future<void> updateProject(Project project) async {
    final projects = await getProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
      await _prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toMap()).toList()));
    }
  }

  /// Supprime un projet par son ID
  Future<void> deleteProject(String projectId) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == projectId);
    await _prefs.setString(_keyProjects, jsonEncode(projects.map((p) => p.toMap()).toList()));
  }



}