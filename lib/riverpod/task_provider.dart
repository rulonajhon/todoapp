import 'package:flutter_riverpod/flutter_riverpod.dart';

class Task {
  final String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void addTask(String title) {
    state = [...state, Task(title: title)];
  }

  void removeTask(Task task) {
    state = state.where((t) => t != task).toList();
  }

  void toggleTaskStatus(Task task) {
    task.isDone = !task.isDone;
    state = [
      for (final t in state)
        if (t == task) Task(title: t.title, isDone: !t.isDone) else t
    ];
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.isDone).toList();
});
