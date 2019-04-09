import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

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

  showPicker(BuildContext context) {
      Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(PickerData)),
        changeToFirst: true,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        }
      );
      picker.show(_scaffoldKey.currentState);
    }

  Drawer get drawer => this._drawer;
}
