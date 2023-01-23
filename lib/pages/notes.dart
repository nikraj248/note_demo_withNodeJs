import 'package:flutter/material.dart';
import 'package:note_demo_nodejs/pages/note_desc.dart';
import 'package:note_demo_nodejs/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const monthsName=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

const colorsCard=[
  0xFFF8BBD0,
  0xFFFF8A80,
  0xFFFFAB91,
  0xFFFFCC80,
  0xFFFFD54F,
  0xFFC5E1A5,
  0xFFB2DFDB];

// bool flag=true;

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);



  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {


  @override
  Widget build(BuildContext context) {

    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    //notesProvider.updateNotesFromCloud();
    // if(notesProvider.database!=null){
    //
    // }
    // if(flag){
    //   print("10000001");
    //   notesProvider.updateNotesFromCloud();
    //   flag=false;
    // }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFE3F2FD),
        // 0xFFE3F2FD
        // 0xFFF8BBD0
        // 0xFFFF8A80
        // 0xFFFFAB91
        // 0xFFFFCC80
        // 0xFFFFD54F
        // 0xFFC5E1A5
        // 0xFFB2DFDB
        appBar: AppBar(
          title: const Text("UserNotes"),
          centerTitle: true,
          // actions: <Widget>[
          //   IconButton(onPressed: (){
          //     setState(() {
          //       notesProvider.updateNotesFromCloud();
          //     });
          //
          //   }, icon: Icon(Icons.refresh))
          // ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [Text("Single Tap to edit"),
                    Text("Double Tap to delete"),],
                ),
              )

            ],
          ),
        ),
        body: (notesProvider.isDataLoading==false)?(notesProvider.notesList.isEmpty==false)?StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            itemCount: notesProvider.notesList.length,
            itemBuilder: (context, index) {

              var p=notesProvider.notesList[index].dateCreated!;
              var t=p.day.toString()+"-"+monthsName[p.month-1]+"-"+p.year.toString();

              return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  //padding: EdgeInsets.all(6),
                  child: Card(
                    elevation: 20,

                    //color: Colors.white70, //Color(0xff252525),
                    color: Color(colorsCard[index%7]),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //maxLines: 1,overflow: TextOverflow.ellipsis,
                            Text(
                              //noteList![index].title,
                              //"hello",
                              notesProvider.notesList[index].title!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Colors.black),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              //noteList![index].date,
                              //"hello",
                              //notesProvider.notesList[index].dateCreated!..format(new DateTime.fromMillisecondsSinceEpoch(values[index]["start_time"]*1000))
                              //notesProvider.notesList[index].dateCreated!.day.toString(),
                              t,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  //noteList![index].description,
                                  //"hello",
                                  notesProvider.notesList[index].description!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black87),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        )),
                  ),
                ),
                onTap: () {
                  //goToEditPage(noteList![index], 'Edit Note');
                  goToEditPage(notesProvider.notesList[index].id!,index,'Edit Note');

                },
                onDoubleTap: () {
                  //_delete(context, noteList![index]);
                  print("11111111111111111111111111111");
                  notesProvider.deleteNote(notesProvider.notesList[index]);
                },
              );
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.fit(1);
            }):const Center(
          child: Text("no notes yet"),//CircularProgressIndicator(),
        ):const Center(
          child: CircularProgressIndicator(),//CircularProgressIndicator(),
    ),


        floatingActionButton: FloatingActionButton(
          tooltip: "Add",
          child: const Icon(Icons.add),
          onPressed: () {
            goToEditPage("",-1,"Add Note");
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void goToEditPage(String noteid,int idx,String appBarTitle) async {

    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(
        NoteId:noteid,
        indexNote:idx,
        appBarTitle: appBarTitle,
      );
    }));

  }

}