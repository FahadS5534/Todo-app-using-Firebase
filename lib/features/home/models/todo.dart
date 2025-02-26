import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { low, medium, high }

class Todo {
  String id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  });

  /// Factory constructor to create a `Todo` from Firestore data.
  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: Priority.values[data['priority']],
      isCompleted: data['isCompleted'],
    );
  }

  /// Converts `Todo` object to Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority.index,
      'isCompleted': isCompleted,
    };
  }

  /// Creates a new `Todo` object with modified fields.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
