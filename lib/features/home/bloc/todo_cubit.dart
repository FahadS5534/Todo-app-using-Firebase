import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/todo.dart';
import '../repository/todo_repository.dart';

part 'todo_states.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository todoRepository;

  TodoCubit({required this.todoRepository}) : super(TodoInitial());

  void fetchTodos() {
    emit(TodoLoading());
    todoRepository.getTodos().listen(
      (todos) {
        emit(TodoLoaded(todos));
      },
      onError: (e) {
        emit(TodoError(e.toString()));
      },
    );
  }

  Future<void> addTodo(Todo todo) async {
    await todoRepository.addTodo(todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await todoRepository.updateTodo(todo);
  }

  Future<void> deleteTodo(String id) async {
    await todoRepository.deleteTodo(id);
  }
}
