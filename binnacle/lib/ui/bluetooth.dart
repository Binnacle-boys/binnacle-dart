import 'package:flutter/material.dart';
import 'package:sos/bloc.dart';
import 'package:sos/providers/app_provider.dart';

class BluetoothButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Icon(Icons.bluetooth),
      shape: CircleBorder(),
      color: Colors.blueAccent,
      onPressed: () => _buildPopup(context)
    );
  }

}


_buildPopup(context) {
      Bloc bloc = Provider.of(context);
      bloc.startScan;
      showDialog(
        context: context,
        builder: (context) =>
         SimpleDialog(
           title: _popupTitle(context, bloc),
           children: [
             Container(
               child: _buildScanResultTiles(context, bloc),
            )
           ],

        )
      );
  
}



 Widget _buildScanResultTiles(BuildContext context, Bloc bloc) {
    return StreamBuilder(
      stream: bloc.scanResults,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
        return Text('no data');
        } else if (snapshot.hasError) {
          return Text('Error');
        } else {
          
          var tiles = new List<Widget>();
          for(var result in snapshot.data.values) {
            if(result.device.name.length > 0)  { 
              tiles.add( _scanResultTile(context, result));

              
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tiles
          );

        }
      }
    );

  }
  Widget _scanResultTile(context, result) {
    Bloc bloc = Provider.of(context);
    return SimpleDialogOption(
      child: Text(
        result.device.name.toString(), textAlign: TextAlign.left),
        onPressed:() => Navigator.pop(context, bloc.connect(result.device))
    );
  }


  Widget _popupTitle(BuildContext context, Bloc bloc) {
    return StreamBuilder(
      stream: bloc.isScanning,
      builder: (context, snapshot)  {
        print("FROM SNAPSHOT "+snapshot.data.toString());
        if(snapshot.hasData) {
          return Column(
            children: (snapshot.data)
            ?<Widget>[
              Text("Scanning....", style: TextStyle(fontSize: 24.0)),
              LinearProgressIndicator()
            ]
            :<Widget>[
              Text("Select device", style: TextStyle(fontSize: 24.0),)
            ]
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          print("Displaying no data yet");
          return Text('No data yet');
        }
      }
    );
  }




