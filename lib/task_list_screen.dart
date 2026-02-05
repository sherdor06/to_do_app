import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/task.dart';
import 'add_task_screen.dart';
import 'database_helper.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

late Future<List<Map<String, dynamic>>?> _taskList;
final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

class _TaskListScreenState extends State<TaskListScreen> {
  Widget buildItem(Task task) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      // ✅ CONFIRM SHU YERDA
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('O‘chirish'),
            content: const Text('Rostan ham o‘chirasizmi?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Yo‘q'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Ha'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        DatabaseHelper.instance.deleteTask(task.id!);
        _updateTaskList();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Task o‘chirildi',
        )));
      },
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(
            task.title!,
            style: TextStyle(
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(
            task.date,
            style: TextStyle(
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          trailing: Checkbox(
            value: task.status == 0 ? false : true,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (bool? value) {
              if (value != null) task.status = value ? 1 : 0;
              DatabaseHelper.instance.updateTask(task);
              _updateTaskList();
            },
          ),
        ),
      ),
    );
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskMapList();
    });
  }

  @override
  void initState() {
    super.initState();
    _taskList = DatabaseHelper.instance.getTaskMapList();

    super.initState();
    _updateTaskList();
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(updateTaskList: _updateTaskList),
          ),
        ),
        child: Icon(Icons.add, color: Colors.green),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Tasks',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return buildItem(Task.fromMap(snapshot.data![index - 1]));
              }
            },
          );
        },
      ),
    );
  }
}
