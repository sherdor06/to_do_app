class Task {
  int? id;
  String? title;
  String date;
  String time;
  String? priority;
  int status ;

  Task(this.id, this.title, this.date, this.priority, this.status, this.time);

  Task.withId({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.priority,
    this.status = 0,

  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {}
    map['id'] = id;
    map['title'] = title;
    map['date'] = date ;
    map['time'] = time;
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'] as int?,
      title: map['title'] as String?,
      date: map['date'] as String? ?? '',      // null-safety
      time: map['time'] as String? ?? '',      // null-safety
      priority: map['priority'] as String?,
      status: map['status'] as int? ?? 0,
    );
  }
}
