class Note {
  int id = 01;
  String date = "";
  String title = "";
  String content = "";

  Note(
      {int id = 01, String date = "", String title = "", String content = ""}) {
    this.id = id;
    this.date = date;
    this.title = title;
    this.content = content;
  }

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = date;
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}
