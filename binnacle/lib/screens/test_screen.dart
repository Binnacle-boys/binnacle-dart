import 'package:flutter/material.dart';
import '../ui/app_drawer.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of(context);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar:
          AppBar(backgroundColor: Colors.blueGrey, title: Text("Test Screen")),
      drawer: AppDrawer(),
      body: _dataList(context, bloc),
    );
  }

  Widget _dataList(context, bloc) {
    List data = [];
    return StreamBuilder(
        stream: bloc.btstream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No bluetooth data sent yet'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            data.insert(0, snapshot.data);
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  Text(data[index].toString()),
              itemCount: data.length,
            );
          }
        });
  }
}
