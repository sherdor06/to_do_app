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
    return ListTile(
      title: Text(
        task.title!,
),
      subtitle: Text(
        task.date,
      ),
      trailing: Checkbox(
        value: task.status == 0 ? false : true,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (bool? value) async {
          if (value != null) {
            task.status = value ? 1 : 0;
            await DatabaseHelper.instance.updateTask(task);

            if (!mounted) return;

            _updateTaskList();
          }
        },
      ),
    );
  }



  void _updateTaskList() {
    if (!mounted) return;
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Row(
          children: [
            Text(
              'To Do List',
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
      body:FutureBuilder<List<Map<String, dynamic>>>(
    future: DatabaseHelper.instance.getTaskMapList(),
    builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No tasks yet"));
      }

      final tasks = snapshot.data!;

      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return buildItem(Task.fromMap(tasks[index]));
        },
      );
    },
    ),
    );
  }
}
