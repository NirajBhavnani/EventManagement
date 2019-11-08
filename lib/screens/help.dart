import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Guide'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: MyBullet(),
            title: Text('The Application consists of two screens:', style: textStyle,),
            subtitle: Text('Event-list And Event-editor', style: Theme.of(context).textTheme.subtitle),
          ),
          ListTile(
            leading: MyBullet(),
            title: Text('Event-list screen have two attributes: Add Event(Bottom Right) and Remove Event(Every member has this button to the right)', style: textStyle,),
          ),
          ListTile(
            leading: MyBullet(),
            title: Text('Event-editor screen have different input fields', style: textStyle,),
          ),
          ListTile(
            leading: MyBullet(),
            title: Text('Points which are required in Event-editor:', style: textStyle,),
            subtitle: Text('1. Title field is compulsory(if not added then an error is thrown) \n2. If date and both the time fields are not selected then it will be set as (default)current date and time of the day/night.', style: Theme.of(context).textTheme.subtitle,),
          ),
        ],
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 15.0,
      width: 15.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
