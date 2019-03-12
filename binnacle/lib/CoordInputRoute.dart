import 'package:flutter/material.dart';

class CoordInputRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Race Coordinates")
      ),
      body: Center(
        child: Form(
          child: ListView(
            children: <Widget>[
              Text("Enter Starting Coordinates",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Latitude"
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(                
                decoration: InputDecoration(
                  labelText: "Longitude"
                ),
                keyboardType: TextInputType.number,
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
              ),
              TextFormField(                
                decoration: InputDecoration(
                  labelText: "Longitude"
                ),
                keyboardType: TextInputType.number,
              ),
              Container(
                child:  RaisedButton(
                  child:  Text(
                    'Submit',
                    style:  TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
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