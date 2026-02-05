// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class TaskEditScreen extends StatefulWidget {
//   const TaskEditScreen({super.key});
//
//   @override
//   State<TaskEditScreen> createState() => _TaskEditScreenState();
// }
// class _TaskEditScreenState extends State<TaskEditScreen> {
//   TextEditingController? get _dateController => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Title"),
//                   onSaved: (input) => _title = input,
//                   validator: (input) =>
//                   input!.trim().isEmpty ? "Please enter a title" : null,
//                 ),
//                 TextFormField(
//                   controller: _dateController,
//                   onTap: _handleDatePicker,
//                   decoration: InputDecoration(
//                     labelText: "Date",
//                     suffixIcon: Icon(Icons.calendar_month),
//                   ),
//                   readOnly: true,
//                   validator: (input) =>
//                   input!.trim().isEmpty ? "Please enter a date" : null,
//                 ),
//                 DropdownButtonFormField(
//                   icon: Icon(Icons.arrow_drop_down),
//                   iconSize: 30,
//                   hint: Text("Priority"),
//                   items: _priorities.map((String priority) {
//                     return DropdownMenuItem(
//                       value: priority,
//                       child: Text(priority, style: TextStyle(fontSize: 15)),
//                     );
//                   }).toList(),
//
//                   decoration: InputDecoration(labelText: "Priority"),
//                   initialValue: _priority,
//                   onSaved: (input) => _priority = input!,
//                   onChanged: (String? value) {},
//                   validator: (input) =>
//                   input!.trim().isEmpty ? "Please enter a priority" : null,
//                 ),
//
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Comment"),
//                 ),
//                 SizedBox(height: 30),
//                 ElevatedButton(onPressed: _submit, child: Text("Save")),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
