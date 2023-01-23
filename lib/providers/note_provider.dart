import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:note_demo_nodejs/services/note_api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/note.dart';

class NotesProvider with ChangeNotifier{
  List<Note> notesList=[];
  bool isDataLoading = true;
  static bool flag = true;

  static Database? _database;
  String noteTable = 'note_table8221101';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'dateCreated';


  NotesProvider(){
    updateNotesFromCloud();
    //flag=false;
  }

  void addNote(Note note){
    notesList.add(note);
    notifyListeners();
    ApiServices.addNoteToCloud(note);
    insertNoteToLocalDb(note);
  }

  void updateNote(Note note){
    print("6666666666666666      "+note.id.toString());
    int idx = notesList.indexOf(notesList.firstWhere((element) => element.id==note.id));
    print("6666666666666666      "+idx.toString());
    notesList[idx]=note;
    notifyListeners();
    ApiServices.addNoteToCloud(note);
    updateNoteToLocalDb(note);
  }

  void deleteNote(Note note){
    print("201");
    int idx = notesList.indexOf(notesList.firstWhere((element) => element.id==note.id));
    notesList.removeAt(idx);
    notifyListeners();
    print("202");
    ApiServices.deleteNoteFromCloud(note);
    deleteNoteToLocalDb(note.id!);
    print("203");
  }


  void updateNotesFromCloud() async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Note> newNotesListFromStorage;

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      print("I am connected to a internet");
      //newNotesListFromStorage = await ApiServices.getAllNotesList();

      List<Note> listFromCloud,listFromLocal;
      listFromCloud = await ApiServices.getAllNotesList();
      listFromLocal = await initialLocalDBsetup();

      await function1(listFromCloud,listFromLocal);

      // print("800");
      // for(int i=0;i<listFromCloud.length;i++){
      //   int isPresent = -1;
      //   for(int j=0;j<listFromLocal.length;j++){
      //     if(listFromCloud[i].id == listFromLocal[j].id){
      //       isPresent = j;
      //       break;
      //     }
      //   }
      //   if(isPresent==-1){
      //     ApiServices.deleteNoteFromCloud(listFromCloud[i]);
      //   }
      //   else{
      //     ApiServices.addNoteToCloud(listFromLocal[isPresent]);
      //   }
      // }
      //
      // print("801");
      // for(int i=0;i<listFromLocal.length;i++){
      //   bool isPresent = false;
      //   for(int j=0;j<listFromCloud.length;j++){
      //     if(listFromCloud[j].id == listFromLocal[i].id){
      //       isPresent = true;
      //       break;
      //     }
      //   }
      //   if(isPresent==false){
      //     ApiServices.addNoteToCloud(listFromLocal[i]);
      //   }
      // }

      print("802");
      newNotesListFromStorage = await initialLocalDBsetup();;

      //uploading data from local to api -> now api contains latest data
      //also copying api's latest data to local cache

    }
    else {
      print("internet not available");
      //here local data will be getting stored if net if off

      newNotesListFromStorage = await initialLocalDBsetup();
    }

    print("constructor called");


    // List<Note> notesListFromLocalDb = await initialLocalDBsetup();

    //List<Note> newListFromCloud = await ApiServices.getAllNotesList();

    //notesListFromLocalDb   -> from localdb
    //newListFromCloud       -> from clouddb
    newNotesListFromStorage.sort((a, b) => a.title!.compareTo(b.title!));
    notesList = newNotesListFromStorage;

    //notesList = <Note>[];
    print("303");
    isDataLoading=false;
    print("304");
    notifyListeners();
    print("305");
  }

  Future<void> function1(List<Note> listFromCloud,List<Note> listFromLocal) async {
    print("800");
    for(int i=0;i<listFromCloud.length;i++){
      int isPresent = -1;
      for(int j=0;j<listFromLocal.length;j++){
        if(listFromCloud[i].id == listFromLocal[j].id){
          isPresent = j;
          break;
        }
      }
      if(isPresent==-1){
        ApiServices.deleteNoteFromCloud(listFromCloud[i]);
      }
      else{
        ApiServices.addNoteToCloud(listFromLocal[isPresent]);
      }
    }

    print("801");
    for(int i=0;i<listFromLocal.length;i++){
      bool isPresent = false;
      for(int j=0;j<listFromCloud.length;j++){
        if(listFromCloud[j].id == listFromLocal[i].id){
          isPresent = true;
          break;
        }
      }
      if(isPresent==false){
        ApiServices.addNoteToCloud(listFromLocal[i]);
      }
    }
  }


  //////////local db


  Future<Database> get database async {
    print("101");
    // _database ??= await initializeDatabase();
    if (_database == null) {
      print("102");
      _database = await initializeDatabase();
    }
    print("103");
    return _database!;
  }


  Future<List<Note>> initialLocalDBsetup() async{
    print("a1");

    Database dbFuture = await initializeDatabase();
    _database=dbFuture;
    List<Note> noteListFuture = await getNoteList();
    return noteListFuture;

    //final Future<Database> dbFuture = initializeDatabase();
    // dbFuture.then((database) {
    //   print("a10");
    //   Future<List<Note>> noteListFuture = getNoteList();
    //   print("a11");
    //   noteListFuture.then((noteList) {
    //     print("a2");
    //     return noteList;
    //   });
    // });

    print("a3");
  }


  Future<Database> initializeDatabase() async {

    print("a4");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes821001.db';

    print("a5   "+path);
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    print(notesDatabase);
    return notesDatabase;
  }

  void _createDb(Database db,int newVersion) async{
    print("a6");
    await db.execute('CREATE TABLE $noteTable($colId TEXT PRIMARY KEY,$colTitle TEXT,$colDescription TEXT,$colDate TEXT)');
  }

  Future<List<Note>> getNoteList() async {
    print("a12");
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = <Note>[];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMap(noteMapList[i]));
    }
    print("a13");
    return noteList;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    print("a14");
    Database db = await database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colDate ASC');
    var result = await db.query(noteTable, orderBy: '$colDate ASC');
    print("a55");
    return result;
  }


  Future<int> insertNoteToLocalDb(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNoteToLocalDb(Note note) async {
    var db = await database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNoteToLocalDb(String id) async {
    print("204");
    var db = await database;
    print("205");
    //int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = ');
    //int result = db.delete(noteTable,where: colId + " = ?"+new String[] { "29e7c8a8-b38b-4812-8a2d" }) as int;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = ?', [id]);
    print("206     "+result.toString());
    return result;
  }


}