import 'package:flutter/material.dart';

class addTimeTable extends StatefulWidget{

  @override
  _addTimeTableState createState() => _addTimeTableState();
}

class _addTimeTableState extends State<addTimeTable> {
  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Add"),
        leading:
        FlatButton(
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Text(
            "취소",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () async{
              },
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
        ],
      ),
      body: Text("hello"),
    );
  }
}