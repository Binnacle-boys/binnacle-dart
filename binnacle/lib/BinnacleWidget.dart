import 'package:flutter/material.dart';
import 'package:sos/providers/app_provider.dart';
import 'dart:async';

import 'package:sos/ui/compass/BinnacleBase.dart';
import 'package:sos/model/DataModel.dart';

class BinnacleWidget extends StatelessWidget {
  BinnacleWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
        body: Column(children: <Widget>[
      //  Transform.rotate(
      Container(
        color: Colors.red,
        // angle: ((direction ?? 0) * (math.pi / 180) * -1),
        child: new BinnacleBase(context),
      )
    ]));
  }
}
