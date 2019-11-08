import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/utils/firestoreservice.dart';
import 'dart:async';


class NoteDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState();
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _rooms = ['Room 1', 'Room 2', 'Room 3', 'Room 4'];
  var _currentItemSelected = '';
  var _fKey = GlobalKey<FormState>();

  String id;
  static int k=0;
  final db = Firestore.instance;
  FirestoreService fireServ = new FirestoreService();

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _timeto = new TimeOfDay.now();

  FirestoreService get user => null;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date) {
      print('Date selected: ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState(() {
        _time = picked;
      });
    }
  }

  Future<Null> _selectTimeto(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _timeto);
    if (picked != null && picked != _timeto) {
      print('Time selected: ${_timeto.toString()}');
      setState(() {
        _timeto = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _rooms[0];
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String collectionName = "Users";
  bool isEditing = false;
  FirestoreService curUser;

  addEvent() {
    FirestoreService user = FirestoreService(
        etitle: titleController.text,
        edes: descriptionController.text,
        eroom: _currentItemSelected,
      edate: _date.toString().substring(0,10),
      etf: _time.toString().substring(10,15),
      ett: _timeto.toString().substring(10,15)
    );
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
              .collection(collectionName)
              .document()
              .setData(user.toJson());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  add() {
    if (isEditing) {
      // Update
      update(curUser, titleController.text, descriptionController.text);
      setState(() {
        isEditing = false;
      });
    } else {
      if(titleController.text.isNotEmpty){
        addEvent();
      }
      else
        {
          debugPrint('Not added');
          k=1;

        }
    }
    titleController.text = '';
    descriptionController.text = '';
  }

  update(FirestoreService user, String newName, String newDesc) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .update(user.reference, {'etitle': newName, 'edes': newDesc});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  setUpdateUI(FirestoreService user) {
    titleController.text = user.etitle;
    descriptionController.text = user.edes;
    setState(() {
      //showTextField = true;
      isEditing = true;
      curUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          title: Text('Event editor'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                moveToLastScreen();
              }),
        ),
        body: Form(
          key: _fKey,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: titleController,
                    style: textStyle,

                    decoration: InputDecoration(
                        labelText: 'Title *',
                        hintText: 'Enter title',
                        helperText: '*Required*',
                        helperStyle: Theme.of(context).textTheme.subtitle,
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,

                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Text('Date selected: ${_date.toString()}'),

                RaisedButton(
                  color: Theme.of(context).secondaryHeaderColor,
                  textColor: Theme.of(context).primaryColorDark,
                  child: Text(
                    'Date',
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    _selectDate(context);
                    setState(() {

                    });
                  },
                ),
                Text(' '),

                Text('From: ${_time.toString()}'),
                Text('To: ${_timeto.toString()}'),
                Text(' '),

                Text(
                  'Time period:',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).secondaryHeaderColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            'From',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            _selectTime(context);
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).secondaryHeaderColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            'To',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            _selectTimeto(context);
                            setState(() {

                              //_delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  title: DropdownButton(
                      items: _rooms.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: _currentItemSelected,
                      onChanged: (String valueSelectedByUser) {
                        setState(() {
                          this._currentItemSelected = valueSelectedByUser;

//                      getEventRoom(valueSelectedByUser);
                        });
                      }),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {

                            add();
                            moveToLastScreen();
                            if(k!=0)
                              _showAlertDialog('Error', 'Please Enter Title');

                            setState(() {

                              setUpdateUI(user);
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Reset',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _reset();
                              //_delete();
                            });

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _reset() {
    titleController.text = '';
    descriptionController.text = '';
    _date = new DateTime.now();
    _time = new TimeOfDay.now();
    _timeto = new TimeOfDay.now();
    _currentItemSelected = _rooms[0];
  }


  void setId() {
    DocumentReference ref;
    setState(() => id = ref.documentID);
    print(ref.documentID);
  }

  void deleteData() async {
    await db.collection('eventlist').document().delete();
    setState(() => id = null);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
