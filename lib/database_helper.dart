import 'models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, time TEXT)');
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER,title TEXT, isDone INTEGER)');
      },
      version: 1,
    );
  }

  Future<List<Task>> getTaskData() async {
    final db = await database();
    List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(
        maps.length,
        (index) => Task(
              id: maps[index]['id'],
              title: maps[index]['title'],
              description: maps[index]['description'],
              time: maps[index]['time'],
            ));
  }

  Future<List<Todo>> getTodoData(int? taskId) async {
    final db = await database();
    List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');

    return List.generate(
        maps.length,
        (index) => Todo(
              id: maps[index]['id'],
              title: maps[index]['title'],
              isDone: maps[index]['isDone'],
              taskId: maps[index]['taskId'],
            ));
  }

  Future<int> insertTask(Task task) async {
    final db = await database();
    // print(task.time);
    // print(DateTime.parse(task.time.toString()));
    final _taskId = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await insertTodo(Todo(title: 'صلاة', taskId: _taskId, isDone: 0));
    await insertTodo(Todo(title: 'قران', taskId: _taskId, isDone: 0));
    await insertTodo(Todo(title: 'تمرين', taskId: _taskId, isDone: 0));
    await insertTodo(Todo(title: 'مذاكرة', taskId: _taskId, isDone: 0));
    return _taskId;
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database();
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database();

    await db.rawUpdate(
      'UPDATE tasks SET title = "${task.title}", description = "${task.description}",time = "${task.time}" WHERE id = ${task.id}',
    );
  }

  Future<void> updateTodoDone(int? id, int? isDone) async {
    final db = await database();

    await db.rawUpdate(
      'UPDATE todo SET isDone = $isDone WHERE id = $id',
    );
  }

  Future<void> deleteTaskTodo(int? taskId) async {
    final db = await database();

    await db.rawDelete(
      'DELETE FROM tasks WHERE id = $taskId',
    );
    await db.rawDelete(
      'DELETE FROM todo WHERE taskId = $taskId',
    );
  }

  Future<void> deleteTodo(int? id) async {
    final db = await database();

    await db.rawDelete(
      'DELETE FROM todo WHERE id = $id',
    );
  }
}
