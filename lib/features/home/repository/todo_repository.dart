import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/home/models/todo.dart';


class TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  TodoRepository({required this.userId});

  Stream<List<Todo>> getTodos() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList());
  }

 Future<void> addTodo(Todo todo) async {
  try {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .add(todo.toFirestore());

    // Now update the document with the generated ID
    await docRef.update({'id': docRef.id});

    print("Todo added with ID: ${docRef.id}");
  } catch (e) {
    print("Error adding todo: $e");
  }
}


  Future<void> updateTodo(Todo todo) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toFirestore());
  }

  Future<void> deleteTodo(String todoId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }
}
