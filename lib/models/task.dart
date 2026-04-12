import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final List<Map<String, dynamic>> subtasks;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.subtasks = const [],
    required this.createdAt,
  });

  // Serialize → Firestore
  Map<String, dynamic> toMap() => {
        'title': title,
        'isCompleted': isCompleted,
        'subtasks': subtasks,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  // Deserialize ← Firestore
  factory Task.fromMap(String id, Map<String, dynamic> data) => Task(
        id: id,
        title: data['title'] ?? '',       
        isCompleted: data['isCompleted'] ?? false,
        subtasks: List<Map<String, dynamic>>.from(data['subtasks'] ?? []),
        // handle both Timestamp AND String (safe fallback)
        createdAt: data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      );

  // Immutable update helper — used when toggling completion
  Task copyWith({
    String? title,
    bool? isCompleted,
    List<Map<String, dynamic>>? subtasks,
  }) =>
      Task(
        id: id,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        subtasks: subtasks ?? this.subtasks,
        createdAt: createdAt,
      );
}