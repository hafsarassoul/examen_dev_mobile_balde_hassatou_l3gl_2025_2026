/**
 * Les modeles sont immutables (final) pour éviter les
 * modifications accidentelles et faciliter la gestion d'etat
 */
class Project {
  final String id;
  final String name;
  final String description;
  final String userId;
  final DateTime createdAt;

  /// Constructeur
  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /**
   * Crée une copie du projet avec des champs modifiés
   * Utilisé dans le ProjectProvider pour mettre à jour les infos
   */
  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? userId,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /**
   * Convertit l'objet Project en Map pour la sérialisation JSON
   */
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /**
   * Crée une instance de Project depuis un Map (SharedPreferences)
   */
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, userId: $userId)';
  }
}