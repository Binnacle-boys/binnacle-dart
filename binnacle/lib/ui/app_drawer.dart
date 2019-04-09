import 'package:flutter/material.dart';

class AppDrawer extends Drawer {
  Drawer _drawer;

  AppDrawer(BuildContext context){
    this._drawer = new Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Compass"),
            subtitle: Text('active compass service'),
            trailing: Icon(Icons.swap_horiz),
            onTap: () {

            },
          ),
        ],
      )
    );
  }

  
  Drawer get drawer => this._drawer;
}
