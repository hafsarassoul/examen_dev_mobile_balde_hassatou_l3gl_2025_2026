import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  // Méthode pour obtenir la couleur selon la priorité
  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.high: return Colors.red;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.low: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Barre de priorité à gauche
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Menu pour Modifier/Supprimer
                PopupMenuButton<String>(
                  onSelected: (val) => val == 'edit' ? onEdit() : onDelete(),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text("Modifier")),
                    const PopupMenuItem(value: 'delete', child: Text("Supprimer", style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge de statut (Cliquable pour changer le statut)
                ActionChip(
                  label: Text(task.status.name.toUpperCase()),
                  onPressed: () {
                    // Logique simple pour basculer de statut
                    final nextStatus = task.status == TaskStatus.todo
                        ? TaskStatus.inProgress
                        : (task.status == TaskStatus.inProgress ? TaskStatus.done : TaskStatus.todo);
                    onStatusChanged(nextStatus);
                  },
                  backgroundColor: _getPriorityColor().withOpacity(0.1),
                  labelStyle: TextStyle(color: _getPriorityColor(), fontSize: 10),
                ),
                Text(
                  "Créé le ${task.createdAt.day}/${task.createdAt.month}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}