import 'package:flutter/material.dart';
import '../models/task.dart'; // Assure-toi d'avoir créé le modèle Task
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  List<Task> _tasks = [];
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  bool _isLoading = false;

  // --- Getters ---

  /// Retourne les tâches filtrées et triées selon les exigences
  List<Task> get tasks {
    List<Task> filtered = _tasks;

    // Application des filtres
    if (_statusFilter != null) {
      filtered = filtered.where((t) => t.status == _statusFilter).toList();
    }
    if (_priorityFilter != null) {
      filtered = filtered.where((t) => t.priority == _priorityFilter).toList();
    }

    // Tri attendu : Statut (inProgress > todo > done) puis Priorité (high > medium > low)
    filtered.sort((a, b) {
      int statusComparison = a.status.index.compareTo(b.status.index);
      if (statusComparison != 0) return statusComparison;
      return a.priority.index.compareTo(b.priority.index);
    });

    return filtered;
  }

  Map<TaskStatus, int> get taskCountByStatus {
    Map<TaskStatus, int> counts = {
      TaskStatus.todo: 0,
      TaskStatus.inProgress: 0,
      TaskStatus.done: 0,
    };
    for (var task in _tasks) {
      counts[task.status] = (counts[task.status] ?? 0) + 1;
    }
    return counts;
  }

  bool get isLoading => _isLoading;

  // --- Méthodes CRUD ---

  Future<void> loadTasks(String projectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final allTasks = await _storageService.getTasks();
      _tasks = allTasks.where((t) => t.projectId == projectId).toList();
    } catch (e) {
      debugPrint("Erreur de chargement des tâches : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(Task task) async {
    await _storageService.saveTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _storageService.updateTask(task);
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _storageService.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    int index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      Task updatedTask = _tasks[index].copyWith(status: status);
      await updateTask(updatedTask);
    }
  }

  // --- Filtres ---

  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }
}