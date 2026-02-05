class Task {
  int? id;
  String? title;
String date;
  String? priority;
  int status ;

  Task(this.id, this.title, this.date, this.priority, this.status);

  Task.withId({
    this.id,
    required this.title,
    required this.date,
    required this.priority,
    this.status = 0,

  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {}
    map['id'] = id;
    map['title'] = title;
    map['date'] = date ;
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      priority: map['priority'],
      status: map['status'] ?? 0,
    );
  }
}
