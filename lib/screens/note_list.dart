import 'package:flutter/material.dart';
import 'package:events/screens/note_detail.dart';
import 'package:events/utils/firestoreservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/utils/Dialogs.dart';
import 'help.dart';


class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;

  String id;
  //final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  Dialogs dialogs = new Dialogs();


  getEvents() {
    return Firestore.instance.collection('Users').snapshots();
  }

  update(FirestoreService user, String newName, String newDesc) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(user.reference, {'etitle': newName, 'edes': newDesc});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  delete(FirestoreService user) {
    Firestore.instance.runTransaction(
          (Transaction transaction) async {
        await transaction.delete(user.reference);
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final event = FirestoreService.fromSnapshot(data);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text('${event.etitle}', style: TextStyle(fontSize: 18),),
          subtitle: Text('Description: ${event.edes},' + ' Room: ${event.eroom.substring(5,6)},\n' + 'Date: ${event.edate},\n' + 'From: ${event.etf},\n' + 'To: ${event.ett}', style: TextStyle(fontSize: 14),),
          leading: CircleAvatar(
            child: Icon(Icons.event),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Remove event',
            onPressed: () {
              // delete
              //delete(event);
              confirmDel(context, 'Remove: ${event.etitle}', 'Are you sure?', data);
            },
          ),
          onTap: () {
            // update
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              tooltip: 'Help',
              onPressed: () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Help();
                  }));
                });
              },
            )
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                dialogs.confirm(context, 'Logout', 'Confirm logout?');
              }),
        ),
        body: buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NoteDetail();
            }));
          },
          tooltip: 'Add Event',
          child: Icon(Icons.add),
        ),
      ),
    );
  }


  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _confirmResultDel(bool isYes , BuildContext context, DocumentSnapshot data){
    final event = FirestoreService.fromSnapshot(data);

    if(isYes){
      print("Delete done" );
      delete(event);
      Navigator.pop(context);
    }
    else{
      print("No Delete");
      Navigator.pop(context);
    }
  }


  confirmDel(BuildContext context,String title,String description, DocumentSnapshot data){

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description),

                ],

              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> _confirmResultDel(true,context,data),
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: ()=> _confirmResultDel(false, context, data),
                child: Text("No"),
              )
            ],
          );
        }
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,

      builder: (context) => new AlertDialog(
        title: new Text('Logout'),
        content: new Text('Confirm logout?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

}
