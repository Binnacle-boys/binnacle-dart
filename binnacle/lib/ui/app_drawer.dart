import 'package:flutter/material.dart';
import 'dart:async'; // shouldn't actually need this when done
import 'package:rxdart/rxdart.dart';
import '../models/service_data.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import '../repository.dart';


class AppDrawer extends Drawer {
  Drawer _drawer;
  Bloc bloc;
  AppDrawer(BuildContext context) {
    bloc = Provider.of(context);
    this._drawer = new Drawer(
      child: providerList(bloc)
      );
  }
  Drawer get drawer => this._drawer;
}

Widget providerList(Bloc bloc) {
  BehaviorSubject<dynamic> _providers = BehaviorSubject();
  _providers.add(providers);


  return StreamBuilder(
    stream: bloc.providerTypes.stream,
    builder: (context, snapshot) {
      if(snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, i) {
            return new ExpansionTile(
            //*  ExpansionTile does not support subtitle
            title: new Text(
              snapshot.data[i].type, 
              style: new TextStyle(
                fontSize: 20.0, 
                fontWeight: FontWeight.bold, 
                fontStyle: FontStyle.italic
              ),
            ),
            children: <Widget>[
              serviceList(bloc, snapshot.data[i].type)
            ],
          );
          }
        );
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return Text("no data yet");
      }
    } ,
  );
}


Widget serviceList(Bloc bloc, type) {
  return StreamBuilder(
    stream: bloc.availableServices.where((value) => value.type == type),
    builder: (context, snapshot) {
      List<Widget> columnContent = [];

      if(snapshot.hasError) {
        columnContent.add(Text(snapshot.error.toString()));
        return Column(children: columnContent,);
      }  
      else if (snapshot.hasData) {
        print("!!!!!!!!!!!!!!!!!!"+ snapshot.data.serviceList.toString());

        for (dynamic wrapper in snapshot.data.serviceList) {
          columnContent.add(
            ListTile(
              title: Text(wrapper.serviceData.name, style: new TextStyle(fontSize: 18.0)),
              onTap: () {
                print('tapping');
                bloc.setActiveService(wrapper.serviceData);
              },
              trailing: activeIndicator(bloc, wrapper.serviceData),
            )
          );
        }
        return Column(children: columnContent,);
      } 
      else {
        columnContent.add(Text('no data yet'));
        return Column(children: columnContent,);
      }
      
    }
  );
    
    

}
Widget activeIndicator(Bloc bloc, ServiceData data) {
  return StreamBuilder(
    stream: bloc.activeServices ,//.where((serviceData) => identical(serviceData, data)),
    builder: (context, snapshot) {
      if(!snapshot.hasData) {
        print('ACTIVE INDICATOR ---- NO DATA');
        return  Icon(Icons.clear)
        ;
      } 
      else if(snapshot.hasError) {
        print('ACTIVE INDICATOR --- ERROR');
        return Icon(Icons.error_outline);
      } else {
        print('ACTIVE INDICATOR --- '+ snapshot.data.name);
        return Opacity(
          opacity: (identical(data, snapshot.data) ? 1.0 :0),
          child: Icon(Icons.check),
        );
      }

    }
  );
}
class _Provider {
  String _type;
  IconData _icon;

  _Provider({String type, icon}) {
    this._type = type;
    this._icon = icon;
  }
  String get type => this._type;
  IconData get icon => this._icon;
}


List<_Provider> providers = [
  new _Provider(
    type:'compass',
    icon: Icons.motorcycle,
  ),
  new _Provider(
    type: 'wind',
    icon: Icons.directions_car,
  ),
];



