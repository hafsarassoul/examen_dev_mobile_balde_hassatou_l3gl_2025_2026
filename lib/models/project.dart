import 'dart:convert';

class Project {
  final String id;
  final String name;
  final String description;
  final String userId; // Pour lier le projet à l'utilisateur connecté
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  // Convertit un objet Project en Map (pour le stockage JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crée un objet Project à partir d'un Map (lecture depuis le stockage)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Méthode pour copier l'objet avec des modifications (Immuabilité)
  Project copyWith({
    String? name,
    String? description,
  }) {
    return Project(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: this.userId,
      createdAt: this.createdAt,
    );
  }
}