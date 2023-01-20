import 'dart:convert';

import '../models/note.dart';
import 'package:http/http.dart' as http;

class ApiServices{
  static String baseServerUrl="https://note-demo-backend-owz8nfsn7-nikraj248.vercel.app/notes";


  static Future<void> addNoteToCloud(Note note) async{
    Uri reqUri = Uri.parse(baseServerUrl+"/add");
    var response = await http.post(reqUri,body: note.toMap());
    var decodedMsg=jsonDecode(response.body.toString());
    print(decodedMsg);
  }

  static Future<void> deleteNoteFromCloud(Note note) async{
    Uri reqUri = Uri.parse(baseServerUrl+"/delete");
    var response = await http.post(reqUri,body: note.toMap());
    var decodedMsg=jsonDecode(response.body.toString());
    print(decodedMsg);
  }

  static Future<List<Note>> getAllNotesList() async{
    Uri reqUri = Uri.parse(baseServerUrl+"/data");
    var response = await http.get(reqUri);
    var decodedMsg=jsonDecode(response.body);
    //print(decodedMsg.toString());
    List<Note> notesListFromCloud=[];
    for(var ele in decodedMsg){
      Note n = Note.fromMap(ele);
      notesListFromCloud.add(n);
    }
    return notesListFromCloud;
    // print(decodedMsg.toString());
    //return [];
  }

}