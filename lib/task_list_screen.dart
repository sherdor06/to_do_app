import 'package:flutter/material.dart';
import 'package:to_do_app/task.dart';
import 'add_task_screen.dart';
import 'database_helper.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Widget buildItem(Task task) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await DatabaseHelper.instance.deleteTask(task.id!);
        setState(() {
          _tasks.remove(task);
        });
      },
      child: ListTile(
        title: Text(
          task.title!,
          maxLines: 3,
          style: TextStyle(
            decoration: task.status == 0
                ? TextDecoration.none
                : TextDecoration.lineThrough,
            color: task.status == 0 ? Colors.black : Colors.grey,
            fontSize: 20,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.time,
              style: TextStyle(
                color: task.status == 0 ? Colors.red : Colors.grey,
              ),
            ),
            Text(
              task.date,
              style: TextStyle(
                color: task.status == 0 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: task.status == 0 ? false : true,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool? value) async {
            if (value != null) {
              task.status = value ? 1 : 0;
              await DatabaseHelper.instance.updateTask(task);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  Future<void> _updateTaskList() async {
    final taskMaps = await DatabaseHelper.instance.getTaskMapList();
    setState(() {
      _tasks = taskMaps.map((e) => Task.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Row(
          children: [
            Text(
              'To do list by Sherdor',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );

          _updateTaskList(); // qaytgandan keyin yangilaymiz
        },
        child: Icon(Icons.add, color: Colors.green),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text("No tasks yet"))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return buildItem(_tasks[index]);
              },
            ),
    );
  }
}
