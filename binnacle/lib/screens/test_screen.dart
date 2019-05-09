import 'package:flutter/material.dart';
import '../ui/app_drawer.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';


class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

   return Scaffold(
     backgroundColor: Colors.grey,
     floatingActionButton: _buildPopup(context),
     
     appBar: AppBar(
       backgroundColor: Colors.blueGrey,
       title: Text("Test Screen")
     ),
     drawer: AppDrawer(),
     body: Column( children: <Widget>[])
   );
  }
}
_buildPopup(context) {
  return FloatingActionButton(backgroundColor: Colors.amber, onPressed: () {
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
  });
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
            if(result.device.name.length.isNotEmpty)  { 
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


class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(result.device.name),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      // leading: Text(result.rssi.toString()),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),

    );
  }
}


