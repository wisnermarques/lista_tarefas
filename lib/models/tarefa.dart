class Tarefa {
  int? id;
  String title;
  DateTime dateTime;

  Tarefa({this.id, required this.title, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
