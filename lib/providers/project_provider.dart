import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/storage_service.dart';


class ProjectProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  // Propriétés privées
  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;

  // Getters publics
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  int get projectCount => _projects.length;
  bool get isLoading => _isLoading;

  // --- MÉTHODES CRUD ---

  /// Charge tous les projets d'un utilisateur spécifique
  Future<void> loadProjects(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // On récupère tous les projets depuis le stockage
      final allProjects = await _storageService.getProjects();

      // On filtre pour ne garder que ceux de l'utilisateur connecté
      _projects = allProjects.where((p) => p.userId == userId).toList();
    } catch (e) {
      debugPrint("Erreur lors du chargement des projets : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crée un nouveau projet
  Future<void> createProject(Project project) async {
    _isLoading = true;
    notifyListeners();

    await _storageService.saveProject(project);
    _projects.add(project);

    _isLoading = false;
    notifyListeners();
  }

  /// Met à jour un projet existant
  Future<void> updateProject(Project project) async {
    await _storageService.updateProject(project);

    // On remplace l'ancien projet par le nouveau dans la liste locale
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  /// Supprime un projet
  Future<void> deleteProject(String projectId) async {
    await _storageService.deleteProject(projectId);
    _projects.removeWhere((p) => p.id == projectId);

    if (_selectedProject?.id == projectId) {
      _selectedProject = null;
    }

    notifyListeners();
  }

  /// Sélectionne un projet pour afficher ses détails
  void selectProject(Project? project) {
    _selectedProject = project;
    notifyListeners();
  }
}