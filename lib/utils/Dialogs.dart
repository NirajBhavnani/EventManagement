import 'package:flutter/material.dart';
import 'dart:async';
class Dialogs{

  information(BuildContext context,String title,String description){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context),
                child: Text("Ok"),
              )
            ],
          );
        }
    );
  }

  waiting(BuildContext context,String title,String description){
    return showDialog(
        context: context,
        barrierDismissible: false,

        builder: (BuildContext context){
          return AlertDialog(


            title: Text(title),
            content: SingleChildScrollView(

              child: ListBody(
                children: <Widget>[

                  Text(description)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context),
                child: Text("Ok"),
              )
            ],
          );
        }
    );
  }


  _confirmResult(bool isYes , BuildContext context){
    if(isYes){
      print("Logout done" );
      Navigator.pop(context);
      Navigator.pop(context, true);
    }
    else{
      print("No logout");
      Navigator.pop(context);
    }
  }

  confirm(BuildContext context,String title,String description){

    return showDialog(
        context: context,
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
                onPressed: ()=> _confirmResult(false,context),
                child: Text("No"),
              ),
              FlatButton(
                onPressed: ()=> _confirmResult(true, context),
                child: Text("Yes"),
              )
            ],
          );
        }
    );
  }

}
