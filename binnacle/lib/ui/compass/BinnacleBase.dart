import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sos/providers/app_provider.dart';
import 'CompassFace.dart';

import 'package:sos/model/Wind.dart';
import 'package:sos/bloc.dart';
import 'package:sos/BinnacleHeadingWidget.dart';

class BinnacleBase extends StatelessWidget {
  BinnacleBase(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return new Container(
      color: Colors.green,
      child: compassLabel(bloc),
    );
  }
}

Widget compassLabel(Bloc bloc) {
  return StreamBuilder(
      stream: bloc.compass,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // TODO this +27 is a total hacky way to fix an offset we are getting
          return Text(((snapshot.data.direction + 27) % 360).toString());
        } else if (snapshot.hasError) {
          return Text('**COMPASS** Hmmm... something went wrong');
        } else {
          return Text('**COMPASS** No data yet');
        }
      });
}

//   @override
//   Widget build(BuildContext context) {
//     return new AspectRatio(
//         aspectRatio: 1.0,
//         child: new Stack(
//           children: <Widget>[
//             new Container(
//               decoration: new BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             new CompassFace(),
//             new BinnacleHeadingWidget(
//                 directionStream: wind.direction?.stream,
//                 color: Colors.lightBlue),
// //            new CompassHeadingWidget(
// //                directionStream: idealBoat.compassHeading.stream,
// //                color: Colors.green),
// //            new CompassHeadingWidget(
// //                directionStream: currentBoat.compassHeading?.stream,
// //                color: Colors.black12)
//             //Other widgets in stack go here like Wind arrows, etc.
//           ],
//         ));
