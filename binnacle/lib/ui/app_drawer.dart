import 'package:flutter/material.dart';
import '../models/service_data.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import '../models/provider_data.dart';
import '../services/service_wrapper_interface.dart';
import 'bluetooth.dart';

class AppDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return new Drawer(child: providerList(bloc));
  }
}

Widget providerList(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.providerData.stream,
    builder: (context, snapshot) {
      List<Widget> widgetList = [
        DrawerHeader(
            child: Container(
          child: BluetoothButton(),
          alignment: Alignment.topRight,
        ))
      ];
      if (snapshot.hasData) {
        for (var item in snapshot.data) {
          String providerType = item.type.toString().split('.').last;
          Widget tile = ExpansionTile(
            key: new Key(providerType),
            title: new Text(providerType, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            leading: modeToggleSwitch(bloc, item),
            children: <Widget>[serviceList(bloc, item.type, item)],
          );
          widgetList.add(tile);
        }

        return ListView(children: widgetList);
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return Text("No data yet");
      }
    },
  );
}

Widget modeToggleSwitch(Bloc bloc, ProviderData providerData) {
  return Switch(
    value: ((providerData.mode == 'auto') ? true : false),
    activeTrackColor: Colors.lightGreenAccent,
    activeColor: Colors.green,
    onChanged: (value) {
      bloc.toggleMode(providerData);
    },
  );
}

Widget serviceList(Bloc bloc, type, providerData) {
  return StreamBuilder(
      stream: bloc.availableServices, 
      builder: (context, snapshot) {
        List<Widget> columnContent = [];

        if (snapshot.hasError) {
          columnContent.add(Text(snapshot.error.toString()));
          return Column(
            children: columnContent,
          );
        } else if (snapshot.hasData) {
          final List<ServiceWrapper> serviceList = snapshot.data.firstWhere((serviceList) => serviceList.type == type).serviceList;

          for (ServiceWrapper wrapper in serviceList) {
            columnContent.add(ListTile(
                enabled: (providerData.mode == 'manual') ? true : false,
                title: Text(wrapper.serviceData.name, style: new TextStyle(fontSize: 18.0)),
                onTap: () {
                  bloc.setActiveService(wrapper.serviceData);
                },
                trailing: (providerData.mode == 'manual') ? activeIndicator(bloc, wrapper.serviceData, type) : Icon(Icons.android)));
          }
          return Column(children: columnContent);
        } else {
          columnContent.add(Text('No data yet'));
          return Column(children: columnContent);
        }
      });
}

Widget activeIndicator(Bloc bloc, ServiceData data, type) {
  return StreamBuilder(
      stream: bloc.activeServices,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Icon(Icons.clear);
        } else if (snapshot.hasError) {
          return Icon(Icons.error_outline);
        } else {
          ServiceData x = snapshot.data.firstWhere((serviceData) => serviceData.category == type);
          return Opacity(
            opacity: (identical(data, x) ? 1.0 : 0.1),
            child: Icon(Icons.check),
          );
        }
      });
}
