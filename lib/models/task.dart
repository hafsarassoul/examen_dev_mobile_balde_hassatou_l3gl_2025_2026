/**
 * Les modeles sont immutables(final) pour éviter les
 * modifications et faciliter la gestion d'etat
 */
enum TaskStatus { inProgress, todo, done }
enum TaskPriority { high, medium, low }

class Task {
  final String id;
  final String title;
  final String description;
  final String projectId;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;

  /// Constructeur
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.projectId,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /**
   * Crée une copie de la tâche avec des champs modifiés
   * Très utile pour changer le statut ou la priorité dans le Provider
   */
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? projectId,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /**
   * Convertir la tâche en Map pour la sérialisation (SharedPreferences)
   */
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'projectId': projectId,
      'status': status.index, // On stocke l'index pour le JSON
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /**
   * Créer une tâche depuis un Map
   */
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      projectId: map['projectId'] as String,
      status: TaskStatus.values[map['status'] as int],
      priority: TaskPriority.values[map['priority'] as int],
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status)';
  }
}