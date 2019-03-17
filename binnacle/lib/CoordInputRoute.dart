import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CoordInputRoute extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CoordInputState();
  }
}



class _CoordInputState extends State<CoordInputRoute>{
  @override
  void initState() {
    super.initState();
  }

  String _startLat;
  String _startLon;
  String _endLat;
  String _endLon;
  final String _url = "https://binnacle-231400.appspot.com/";

  final _formKey = new GlobalKey<FormState>();


  Future<String> getRoute() async {
    var url = _url + "?x1=${_startLat}&y1=${_startLon}&x2=${_endLat}&y2=${_endLon}";
    print("url = " + url);

    var res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json "});
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      print("Flask Server Response:" + res.body);
    }
    else {
      // If that response was not OK, throw an error.
      print("Response error: "+res.body);
      throw Exception('Failed to get a response from Flask Server');
    }


    print(res.body);
    return "Success!";
  }
  String isValidLat(value) {
    double val = double.parse(value);
    if(val.isNaN) {
      return "This is not a number";
    }
    if(val < -90.0 || val > 90.0) {
      return "This is not a valid latitude";
    }
    print("!!!!!!!!!!!!!!!!!!!!!! : val");
    return null;

  }


  void _submit(context) {
    final form = _formKey.currentState;
    form.save();
    getRoute();


    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Race Coordinates")
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text("Enter Starting Coordinates",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Latitude",
                ),
                keyboardType: TextInputType.number,
                onSaved: (input) => _startLat = input
              ),
              TextFormField(                
                decoration: InputDecoration(
                  labelText: "Longitude"
                ),
                keyboardType: TextInputType.number,
                onSaved: (input) => {_startLon = input}
              ),
              Text("Enter Finishing Coordinates",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Latitude"
                ),
                keyboardType: TextInputType.number,
                onSaved: (input) => {_endLat = input}
              ),
              TextFormField(                
                decoration: InputDecoration(
                  labelText: "Longitude"
                ),
                keyboardType: TextInputType.number,
                onSaved: (input) => {_endLon = input}
              ),
              Container(
                child:  RaisedButton(
                  child:  Text(
                    'Submit',
                    style:  TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () => _submit(context),
                  color: Colors.blueGrey,
                ),
                margin: new EdgeInsets.only(
                  top: 20.0
                ),
              )
            ],
          )

        )
      )
    );
  }


  
}