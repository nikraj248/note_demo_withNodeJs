import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_demo_nodejs/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';


class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final int indexNote;
  final String NoteId;

  const NoteDetail({Key? key,required this.appBarTitle, required this.indexNote, required this.NoteId}) : super(key: key);


  @override
  State<NoteDetail> createState() => _NoteDetailState(this.appBarTitle,this.indexNote,this.NoteId);
}

class _NoteDetailState extends State<NoteDetail> {

  String appBarTitle;
  int indexNote;
  String NoteId;
  _NoteDetailState(this.appBarTitle,this.indexNote,this.NoteId);


  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  //get uuid => null;


  @override
  Widget build(BuildContext context) {

    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    if(indexNote!=-1){
       titleController.text=notesProvider.notesList[indexNote].title!;
       descController.text=notesProvider.notesList[indexNote].description!;
    }
    // titleController.text=note.title;
    // descController.text=note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          moveToLastScreen();
        },),
        actions: <Widget>[
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Delete Note"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  //_delete();
                  deleteNote();
                }
              }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 40,left: 10,right: 10,bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  maxLines: null,
                  onChanged: (value){
                    //updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: "TITLE",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)
                      )
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: descController,
                  maxLines: null,
                  onChanged: (value){
                    //updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)
                      )
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(onPressed: (){
                      //_save();
                      //saveNewNote();
                      indexNote==-1?saveNewNote():updateNote();
                    }, child: Text("SAVE"),
                      style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),),
                    //
                    // const SizedBox(width: 20,),

                    // ElevatedButton(onPressed: (){
                    //   _delete();
                    // }, child: Text("DELETE"),
                    //   style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveNewNote(){
    var uuid = Uuid();

// // Generate a v1 (time-based) id
//     uuid.v1();
    Note newNote = Note(
      id: uuid.v1(),
      title: titleController.text,
      description: descController.text,
      dateCreated: DateTime.now()
    );
    Provider.of<NotesProvider>(context,listen: false).addNote(newNote);
    moveToLastScreen();
  }

  void updateNote(){
    Note newNote = Note(
        id: NoteId,
        title: titleController.text,
        description: descController.text,
        dateCreated: DateTime.now()
    );
    print("222222222222222   "+newNote.id.toString());
    Provider.of<NotesProvider>(context,listen: false).updateNote(newNote);
    print("33333333333333");
    moveToLastScreen();
    print("444444444444444");
  }

  void deleteNote(){
    print("9999999999999999999999");
    Provider.of<NotesProvider>(context,listen: false).deleteNote(Provider.of<NotesProvider>(context,listen: false).notesList[indexNote]);
    print("8888888888888888888888");
    moveToLastScreen();

  }

  void moveToLastScreen(){
    Navigator.pop(context);
  }


}