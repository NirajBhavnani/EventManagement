import 'package:flutter/material.dart';
import 'package:events/screens/note_list.dart';


class User extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UserState();
  }
}
class UserState extends State<User>{
  var _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  var _users = ['Anjali Chachra', 'Niraj Bhavnani', 'Ruchika Patil', 'Heena Bhavnani', 'a'];
  String username = '';

  @override
  void initState() {
    super.initState();
    username = _users[0];
  }


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('User login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[

              Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Center(
                    child: Text(
                      "KJSCE Event Management",
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepPurple
                      ),
                    ),
                  )),

              getImageAsset(),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  style: textStyle,
                  controller: userController,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Please enter your user name';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Input user name',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 80.0, left: 80.0),
                child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Login',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        int j,k;
                        if(_formKey.currentState.validate()){
                          for(j=0; j<_users.length; j++){
                            if(userController.text == _users[j]){
                              k = 1;
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return NoteList();
                              }));
                              break;
                            }
                            else{
                              k = 0;
                            }
                          }
                          if(k == 1){
                            _showAlertDialogUser('Status','You are logged in as: ${_users[j]}');
                          }
                          else if(k == 0){
                            _showAlertDialogUser('Status', 'You are not authorized now');
                          }
                        }
                      });
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/Event.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(50.0),
    );
  }

  void _showAlertDialogUser(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}