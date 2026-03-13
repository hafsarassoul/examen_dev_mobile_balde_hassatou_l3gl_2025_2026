import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/models/project.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/project_provider.dart';
import '../../../widgets/cards/project_card.dart';
import '../../projects/project_details_screen.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: context.read<ProjectProvider>(),
      builder: (context, _) {
        final projectProvider = context.watch<ProjectProvider>();
        final projects = projectProvider.projects;

        // Gestion de l'état vide
        if (projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "Aucun projet pour le moment",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showAddProjectDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Créer mon premier projet"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        // Liste des projets
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProjectCard(
                project: project,
                taskCount: 0, // À lier avec ton TaskProvider plus tard
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailsScreen(project: project),
                    ),
                  );
                },
                onEdit: () {
                  // Logique de modification
                },
                onDelete: () {
                  _showDeleteConfirmation(context, projectProvider, project.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  // Dialogue de création
  void _showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouveau Projet"),
        content: const Text("Le formulaire de création sera implémenté dans la partie suivante."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  // Confirmation de suppression
  void _showDeleteConfirmation(BuildContext context, ProjectProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer le projet ?"),
        content: const Text("Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProject(id);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  void _showEditProjectDialog(BuildContext context, Project project) {
    final nameController = TextEditingController(text: project.name);
    final descController = TextEditingController(text: project.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier le projet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom du projet"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              // On appelle le provider pour mettre à jour
              context.read<ProjectProvider>().updateProject(
                project.id as Project,
              );
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Projet mis à jour !")),
              );
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }
}