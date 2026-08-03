class Task {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;
  final int owner;

  Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.description,
    required this.owner,
    required this.createdAt
  });

  factory Task.fromJson(Map<String,dynamic> json){
    return Task(
      id:json["id"],
      title:json["title"],
      description: json["description"],
      completed: json["completed"],
      createdAt: DateTime.parse(json["created_at"]),
      owner: json["owner"],
    );
}
}

