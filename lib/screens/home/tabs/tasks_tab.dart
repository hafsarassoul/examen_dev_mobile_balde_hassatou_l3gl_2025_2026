import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/task_provider.dart';
import '../../../models/task.dart'; 

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  String _selectedFilter = 'all'; // Filtre par défaut

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Barre de filtrage par statut (Exigence 4.4)
        _buildFilterBar(),

        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              // On applique le filtre sur la liste des tâches
              final filteredTasks = taskProvider.tasks.where((task) {
                if (_selectedFilter == 'all') return true;
                return task.status.name == _selectedFilter;
              }).toList();

              // 2. État vide (Exigence 4.4)
              if (filteredTasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined,
                          size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        "Aucune tâche trouvée",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              // 3. Liste des tâches
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: _buildStatusIndicator(task.status),
                      title: Text(task.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Priorité: ${task.priority}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Options pour modifier/supprimer la tâche
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget pour la barre de filtres
  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _filterChip('Tous', 'all'),
          _filterChip('À faire', 'todo'),
          _filterChip('En cours', 'inProgress'),
          _filterChip('Terminés', 'done'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) setState(() => _selectedFilter = value);
        },
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Petit indicateur de couleur selon le statut
  Widget _buildStatusIndicator(TaskStatus status) {
    Color color;
    switch (status) {
      case TaskStatus.todo: color = Colors.orange; break;
      case TaskStatus.inProgress: color = Colors.blue; break;
      case TaskStatus.done: color = Colors.green; break;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}