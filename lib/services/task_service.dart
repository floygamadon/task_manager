import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // ── Add task to Firestore ────────────────────────────────────
  Future<void> addTask(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return; // Block empty submissions

    await _tasksCollection.add({
      'title': trimmedTitle,
      'isCompleted': false,
      'subtasks': [],
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ── Update task in Firestore ─────────────────────────────────
  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  // ── Delete task from Firestore ───────────────────────────────
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  // ── Stream tasks from Firestore ──────────────────────────────
  Stream<List<Task>> streamTasks() {
    return _tasksCollection
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }
}