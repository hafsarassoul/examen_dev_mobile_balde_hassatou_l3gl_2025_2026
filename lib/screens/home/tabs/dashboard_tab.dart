import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/cards/project_card.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  // 1. Message de bienvenue dynamique selon l'heure
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Bonjour";
    if (hour < 18) return "Bon après-midi";
    return "Bonsoir";
  }

  @override
  Widget build(BuildContext context) {

    final user = context.watch<AuthProvider>().currentUser;


    final projectProvider = context.read<ProjectProvider>();
    final taskProvider = context.read<TaskProvider>();

    //  ListenableBuilder : Reconstruit l'UI uniquement quand les données changent
    return ListenableBuilder(
      listenable: projectProvider,
      builder: (context, _) {
        return RefreshIndicator(
          // 3. RefreshIndicator pour rafraîchir les données
          onRefresh: () async {
            await projectProvider.fetchProjects();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de bienvenue dynamique
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_getGreeting()},", // fonction Bonjour/Bonsoir
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        user?.name ?? 'Utilisateur',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${_getGreeting()}, ${user?.name ?? 'Utilisateur'}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                        "Projets",
                        "${projectProvider.projects.length}",
                        Icons.folder_copy_outlined,
                        Colors.blue
                    ),
                    _buildStatCard(
                        "À faire",
                        "${taskProvider.todoCount}",
                        Icons.assignment_outlined,
                        Colors.orange
                    ),
                    _buildStatCard(
                        "En cours",
                        "${taskProvider.inProgressCount}",
                        Icons.sync,
                        Colors.purple
                    ),
                    _buildStatCard(
                        "Terminés",
                        "${taskProvider.doneCount}",
                        Icons.check_circle_outline,
                        Colors.green
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Projets récents",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: const Text("Voir tout"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (projectProvider.projects.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("Aucun projet enregistré."),
                    ),
                  )
                else

                  ...projectProvider.projects.reversed.take(3).map((project) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProjectCard(
                        project: project,
                        taskCount: 0,
                        onTap: () {

                        },
                        onEdit: () {},
                        onDelete: () {},
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}