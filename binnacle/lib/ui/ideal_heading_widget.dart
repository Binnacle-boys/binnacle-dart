import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sos/models/ideal_heading_model.dart';
import 'package:sos/ui/global_theme.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';

class IdealHeadingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc bloc = Provider.of(context);
    return StreamBuilder(
        stream: bloc.idealHeading,
        builder: (context, AsyncSnapshot<IdealHeadingModel> snapshot) {
          if (snapshot.hasData) {
            // return CircularProgressIndicator();
            return Stack(children: [
              new Transform.rotate(
                  angle: (snapshot.data.direction * pi / 180),
                  child: new Align(
                    alignment: Alignment.center,
                    child: CustomPaint(painter: IdealHeadingArrowPainter(superContext: context)),
                  )),
            ]);
          } else if (snapshot.hasError) {
            print("Stream error in list_angle_widget.dart -> listAngleStreamBuilder");
            return Text(' ');
          } else {
            return Container();
          }
        });
  }
}

class IdealHeadingArrowPainter extends CustomPainter {
  Color lineColor;

  double width = 10;
  BuildContext superContext;

  IdealHeadingArrowPainter({this.superContext});
  @override
  void paint(Canvas canvas, Size size) {
    var theme = GlobalTheme();
    Paint complete = new Paint()
      ..color = theme.backgroundColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Path path = new Path();
    // Tuples points for the shape
    List<List<double>> tuples = [
      [-2, 25],
      [5, 25],
      [5, 250],
      [9, 250],
      [10, 300],
      [17, 300],
      [17, 250],
      [21, 250],
      [20, 25],
      [27, 25],
      [13, 0],
    ];

    List<Offset> l = tuples.map((t) => Offset(t[0] - 13, t[1] - 150)).toList();
    path.addPolygon(l, true);

    path.close();
    //path = path.shift(Offset(-92, -250));
    canvas.drawPath(path, complete);

    complete.color = theme.primaryColor;
    complete.strokeWidth = 3;
    canvas.drawPath(path, complete);

    complete.color = theme.backgroundColor;
    complete.style = PaintingStyle.fill;
    canvas.drawPath(path, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
