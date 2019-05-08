import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sos/ui/global_theme.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';

class ListAngleUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: listAngleStreamBuilder(context),
    );
  }
}

Widget listAngleStreamBuilder(BuildContext context) {
  Bloc bloc = Provider.of(context);
  return StreamBuilder(
      stream: bloc.listAngle, //take(5).reduce((x,y) => ListAngleModel(x.angle + y.angle))),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
              child: Stack(children: <Widget>[
            new Center(
                child: Container(
                    height: 50.0,
                    width: 50.0,
                    child: new CustomPaint(foregroundPainter: new levelLinePainter(lineColor: GlobalTheme().listAngleColor)))),
            new Center(
                child: new Transform.rotate(

                    // TODO still gittery
                    angle: (snapshot.data.angle + 5 * pi / 6),
                    child: Container(
                        height: 50.0,
                        width: 50.0,
                        child: new CustomPaint(foregroundPainter: new reticlePainter(lineColor: GlobalTheme().listAngleColor, width: 2.0)))))
          ]));
        } else if (snapshot.hasError) {
          print("Stream error in list_angle_widget.dart -> listAngleStreamBuilder");
          return Text(' ');
        } else {
          return CircularProgressIndicator();
        }
      });
}

class reticlePainter extends CustomPainter {
  Color lineColor;

  double width;

  reticlePainter({this.lineColor, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = 40.0;
    Path path = new Path();

    double a = 0.0;

    for (var i = 0.0; i < 17; i += 1) {
      a = (i * pi / 12);

      path.moveTo(size.width / 2, size.height / 2);
      path.relativeMoveTo(40 * cos(a), 40 * sin(a));
      if (i % 4 == 0) {
        path.relativeLineTo(13 * cos(a), 13 * sin(a));
      } else {
        path.relativeLineTo(5 * cos(a), 5 * sin(a));
      }
    }

    path.close();
    canvas.drawPath(path, complete);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), 0, pi * 1.33, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class levelLinePainter extends CustomPainter {
  Color lineColor;

  double width = 2;

  levelLinePainter({this.lineColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Path path = new Path();

    path.moveTo(size.width / 2, size.height / 2 - 15);
    path.lineTo(size.width / 2, -30);

    path.close();
    canvas.drawPath(path, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
