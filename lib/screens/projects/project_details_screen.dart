import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/project.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name ?? "Détails du projet"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(project.description ?? "Aucune description"),
            const Divider(height: 32),
            // Ici, tu ajouteras plus tard la liste des tâches (Partie 5)
            const Text("Liste des tâches à venir..."),
          ],
        ),
      ),
    );
  }
}