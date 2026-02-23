import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/task.dart';

class AddTaskScreen extends StatefulWidget {

  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _title = "";
  String? _priority = "Low";
  final DateTime _date = DateTime.now();
  String? _comment = "";

  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  void _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2050),
      initialDate: _date,
    );
    if (date != _date) {
      setState(() {
      });
      _dateController.text = _dateFormatter.format(date!);
    }
  }

  Future<void> _submit() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      final task = Task.withId(
        title: _title!,
        date: _dateFormatter.format(_date),
        priority: _priority!,
      );

      await DatabaseHelper.instance.insertTask(task);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Title"),
                  onSaved: (input) => _title = input,
                  validator: (input) =>
                      input!.trim().isEmpty ? "Please enter a title" : null,
                ),
                TextFormField(
                  controller: _dateController,
                  onTap: _handleDatePicker,
                  decoration: InputDecoration(
                    labelText: "Date",
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  readOnly: true,
                  validator: (input) =>
                      input!.trim().isEmpty ? "Please enter a date" : null,
                ),
                DropdownButtonFormField(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  hint: Text("Priority"),
                  items: _priorities.map((String priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority, style: TextStyle(fontSize: 15)),
                    );
                  }).toList(),

                  decoration: InputDecoration(labelText: "Priority"),
                  initialValue: _priority,
                  onSaved: (input) => _priority = input!,
                  onChanged: (String? value) {},
                  validator: (input) =>
                      input!.trim().isEmpty ? "Please enter a priority" : null,
                ),

                TextFormField(
                  decoration: InputDecoration(labelText: "Comment"),
                ),
                SizedBox(height: 30),
                ElevatedButton(onPressed: _submit, child: Text("Save")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
