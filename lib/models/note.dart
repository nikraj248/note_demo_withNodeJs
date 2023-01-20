class Note{
  String? id;
  String? title;
  String? description;
  DateTime? dateCreated;

  Note({this.id,this.title,this.description,this.dateCreated});

  factory Note.fromMap(Map<String,dynamic> mp){
    return Note(
      id:mp["id"],
      title:mp["title"],
      description:mp["description"],
      dateCreated:DateTime.tryParse(mp["dateCreated"]),
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "title":title,
      "description":description,
      "dateCreated":dateCreated!.toIso8601String(),
    };
  }

}