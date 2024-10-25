import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/riverpod/task_provider.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks =
        ref.watch(taskProvider).where((task) => !task.isDone).toList();
    final taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedTasksScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Enter a task'),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                ref.read(taskProvider.notifier).addTask(taskController.text);
                taskController.clear();
              }
            },
            child: Text('Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Checkbox(
                    value: task.isDone,
                    onChanged: (value) {
                      ref.read(taskProvider.notifier).toggleTaskStatus(task);
                    },
                  ),
                  onLongPress: () {
                    ref.read(taskProvider.notifier).removeTask(task);
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

class CompletedTasksScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTasks = ref.watch(completedTasksProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          );
        },
      ),
    );
  }
}
