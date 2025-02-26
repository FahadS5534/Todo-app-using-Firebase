import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/auth/presentation/login_page.dart';
import 'package:myapp/features/home/bloc/todo_cubit.dart';
import 'package:myapp/features/home/models/todo.dart';
import 'package:myapp/features/home/repository/todo_repository.dart';

class HomePage extends StatelessWidget {
  final TodoRepository todoRepository;
  final String userId;

  HomePage({required this.userId})
      : todoRepository = TodoRepository(userId: userId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TodoCubit(todoRepository: todoRepository)..fetchTodos(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(162), // Increased height
          child: Container(
            padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Color(0xFF9C8DF2), // Light purple shade
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // Rounded bottom
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.grid_view,
                        color: Colors.white, size: 28), // Left icon
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                        onSelected: (value) => {
                              if (value == "logout")
                                {
                                  FirebaseAuth.instance.signOut(),
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()))
                                }
                            },
                        icon: Icon(Icons.more_horiz,
                            color: Colors.white, size: 28),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: "logout",
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text("Logout"),
                                  ],
                                ),
                              )
                            ]), // Right icon
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Today, ${DateTime.now().day} Feb",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  "My tasks",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildTaskSection(
                      "Today", state.todos, DateTime.now(), context),
                  _buildTaskSection("Tomorrow", state.todos,
                      DateTime.now().add(Duration(days: 1)), context),
                  _buildTaskSection("This week", state.todos,
                      DateTime.now().add(Duration(days: 7)), context),
                ],
              );
            } else if (state is TodoError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("No tasks yet!"));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF9C8DF2),
        ),
      ),
    );
  }

  Widget _buildTaskSection(
      String title, List<Todo> todos, DateTime date, BuildContext context) {
    List<Todo> filteredTodos =
        todos.where((todo) => todo.dueDate.day == date.day).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...filteredTodos.map((todo) => _buildTaskTile(todo, context)).toList(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTaskTile(Todo todo, BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        BlocProvider.of<TodoCubit>(context).deleteTodo(todo.id);
      },
      child: Card(
        child: ListTile(
          title: Text(todo.title),
          subtitle: Text(todo.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _priorityLabel(todo.priority),
              Checkbox(
                value: todo.isCompleted,
                onChanged: (value) {
                  final updatedTodo = todo.copyWith(isCompleted: value);
                  BlocProvider.of<TodoCubit>(context).updateTodo(updatedTodo);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityLabel(Priority priority) {
    Color color;
    switch (priority) {
      case Priority.low:
        color = Colors.green;
        break;
      case Priority.medium:
        color = Colors.orange;
        break;
      case Priority.high:
        color = Colors.red;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        priority.toString().split('.').last,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    Priority selectedPriority = Priority.medium;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Add Task",
            style: TextStyle(color: Color(0xFF9C8DF2)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              DropdownButtonFormField<Priority>(
                value: selectedPriority,
                onChanged: (value) {
                  if (value != null) selectedPriority = value;
                },
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    descController.text.isEmpty) {
                  print("❌ Title or Description is empty!");
                  return;
                }

                final newTodo = Todo(
                  id: '',
                  title: titleController.text,
                  description: descController.text,
                  dueDate: DateTime.now(),
                  priority: selectedPriority,
                  isCompleted: false,
                );
                DocumentReference docRef = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('todos')
                    .add(newTodo.toFirestore());

                await docRef.update({'id': docRef.id});
                BlocProvider.of<TodoCubit>(context).addTodo(newTodo);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
