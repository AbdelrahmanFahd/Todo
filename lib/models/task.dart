class Task {
  final int? id;
  final String? title;
  final String? description;
  final String? time;

  Task({this.id, this.title, this.description, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
    };
  }
}
