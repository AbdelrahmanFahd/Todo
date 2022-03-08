class Todo {
  final int? id;
  final int? taskId;
  final int? isDone;
  final String? title;
  Todo({this.taskId, this.isDone, this.id, this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
    };
  }
}
