import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TaskService _taskService = TaskService();

  // ── Firestore version (Phase D) ─────────────────────────────
  // Add a task
  Future<void> _addTask() async {
    final title = _taskController.text.trim();
    if (title.isEmpty) return; // Block empty submissions

    await _taskService.addTask(title);
    _taskController.clear();
  }

  // Toggle isCompleted in Firestore
  Future<void> _toggleTask(Task task) async {
    final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
      );
    await _taskService.updateTask(updatedTask);
  }

  // Permanently delete a task with a confirmation message
  Future<void> _confirmDelete(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _taskService.deleteTask(task.id);
    }
  }

  @override
  void dispose() {
    _taskController.dispose(); // IMPORTANT: always dispose controllers
    _searchController.dispose(); // IMPORTANT: dispose search controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          // ── Input row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'New task name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // ── Search bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                setState(() {}); // Rebuild UI as user types
              },
            ),
          ),
          const SizedBox(height: 8),

          // ── Task list from Firestore stream ──────────────────────────────────────────
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.streamTasks(),
              builder: (context, snapshot) {
                // State 1: Still connecting to Firestore
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } 

                // State 2: Stream returned an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // State 3: Data arrived
                final tasks = snapshot.data ?? [];
                final query = _searchController.text.trim().toLowerCase();

                final filteredTasks = query.isEmpty
                    ? tasks
                    : tasks.where((task) {
                        return task.title.toLowerCase().contains(query);
                      }).toList();

                // State 4: Collection is empty
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks yet. Add one above!'),
                  );
                } 

                // State 5: Search returned no matches
                if (filteredTasks.isEmpty) {
                  return const Center(
                    child: Text('No matching tasks found.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];

                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTask(task), 
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(task),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}