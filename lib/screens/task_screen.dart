import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import '../widgets.dart' as wg;
import '../database_helper.dart';
import '../models/task.dart';
import '../models/todo.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({required this.task, Key? key}) : super(key: key);
  final Task? task;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final dbHelper = DatabaseHelper();

  String? _taskTitle;
  String? _taskDescription;
  int? _taskId;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController todoController = TextEditingController();
  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final todoFocusNode = FocusNode();
  bool isVisible = false;

  final formKey = GlobalKey<FormState>();

  void trySubmit() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      if (_taskId == null) {
        final _newTask = Task(title: _taskTitle, description: _taskDescription);
        _taskId = await dbHelper.insertTask(_newTask);
        setState(() {
          isVisible = true;
        });
      } else {
        final _updateTask =
            Task(id: _taskId, title: _taskTitle, description: _taskDescription);
        await dbHelper.updateTask(_updateTask);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Task update successfully !',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 19,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          duration: const Duration(seconds: 1),
        ));
      }
    }
  }

  void deleteTask() async {
    await dbHelper.deleteTaskTodo(_taskId);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Task deleted successfully',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 19, color: Colors.black54, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      duration: const Duration(seconds: 1),
    ));
    Navigator.of(context).pop();
  }

  void deleteTodo(int? id) async {
    await dbHelper.deleteTodo(id);
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description;
      _taskId = widget.task!.id;
      titleController.text = _taskTitle.toString();
      descriptionController.text = _taskDescription.toString();
      isVisible = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Stack(children: [
          Column(
            children: [
              // First Row
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 6),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(Icons.arrow_back_rounded, size: 28),
                      ),
                    ),

                    //Title Task

                    Expanded(
                      child: TextFormField(
                        focusNode: titleFocusNode,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          hintText: 'Enter Task Title',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfd211551)),
                        controller: titleController.text != 'null'
                            ? titleController
                            : null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Title must be at least one character !';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _taskTitle = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Description Task
              TextFormField(
                controller: descriptionController.text != 'null'
                    ? descriptionController
                    : null,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Enter Description for the Task ......',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                ),
                onSaved: (value) {
                  _taskDescription = value;
                },
              ),

              // ToDoo Tasks

              Visibility(
                visible: isVisible,
                child: Expanded(
                  child: FutureBuilder(
                    initialData: [Todo()],
                    future: dbHelper.getTodoData(_taskId),
                    builder: (ctx, AsyncSnapshot<List<Todo>> snapShot) =>
                        ListView.builder(
                      itemCount: snapShot.data!.length,
                      itemBuilder: (ctx, index) => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (snapShot.data![index].isDone == 0) {
                                  dbHelper.updateTodoDone(
                                      snapShot.data![index].id, 1);
                                } else {
                                  dbHelper.updateTodoDone(
                                      snapShot.data![index].id, 0);
                                }
                                setState(() {});
                              },
                              child: wg.Todo(
                                  title: snapShot.data![index].title,
                                  isDone: snapShot.data![index].isDone == 1
                                      ? true
                                      : false),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                deleteTodo(snapShot.data![index].id);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Color(0xFF86829D),
                                size: 25,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Enter ToDoo

              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: const Icon(Icons.check_box_outline_blank_rounded,
                            size: 24, color: Color(0xFF86829D)),
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: todoFocusNode,
                          controller: todoController,
                          onFieldSubmitted: (value) async {
                            if (value != null) {
                              if (_taskId != null) {
                                final dbHelper = DatabaseHelper();
                                final _newTodo = Todo(
                                    title: value, taskId: _taskId, isDone: 0);
                                await dbHelper.insertTodo(_newTodo);
                                todoController.clear();
                                setState(() {});
                              } else {
                                print('task does not exist');
                              }
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter Todo item .... ',
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Delete Button
          Visibility(
            visible: isVisible,
            child: Positioned(
              bottom: 100.0,
              right: 24.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFFE3577),
                    minimumSize: const Size(60, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: deleteTask,
                child: const Icon(Icons.delete_forever, size: 30),
              ),
            ),
          ),

          // Save Button

          Positioned(
            bottom: 24.0,
            right: 24.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF7349FE),
                  minimumSize: const Size(60, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              onPressed: trySubmit,
              child: const Icon(Icons.save_rounded, size: 30),
            ),
          ),
        ]),
      )),
    );
  }
}
