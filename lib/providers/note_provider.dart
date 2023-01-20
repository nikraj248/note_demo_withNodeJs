import 'package:flutter/material.dart';
import 'package:note_demo_nodejs/services/note_api_service.dart';

import '../models/note.dart';

class NotesProvider with ChangeNotifier{
  List<Note> notesList=[];
  bool isDataLoading = true;
  NotesProvider(){
    updateNotesFromCloud();
  }

  void addNote(Note note){
    notesList.add(note);
    notifyListeners();
    ApiServices.addNoteToCloud(note);
  }

  void updateNote(Note note){
    print("6666666666666666      "+note.id.toString());
    int idx = notesList.indexOf(notesList.firstWhere((element) => element.id==note.id));
    print("6666666666666666      "+idx.toString());
    notesList[idx]=note;
    notifyListeners();
    ApiServices.addNoteToCloud(note);
  }

  void deleteNote(Note note){
    int idx = notesList.indexOf(notesList.firstWhere((element) => element.id==note.id));
    notesList.removeAt(idx);
    notifyListeners();
    ApiServices.deleteNoteFromCloud(note);
  }


  void updateNotesFromCloud() async{
    List<Note> newListFromCloud = await ApiServices.getAllNotesList();
    notesList = newListFromCloud;
    isDataLoading=false;
    notifyListeners();
  }


}