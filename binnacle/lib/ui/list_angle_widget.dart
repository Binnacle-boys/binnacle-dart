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
          return Stack(children: <Widget>[
            new Container(
                alignment: Alignment.bottomCenter,
                height: 50.0,
                width: 50.0,
                child: new CustomPaint(foregroundPainter: new levelLinePainter(lineColor: GlobalTheme().listAngleColor))),
            new Transform.translate(
                offset: Offset((snapshot.data.angle * (180 / pi) - 151), 0),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 50.0,
                    width: 50.0,
                    child: new CustomPaint(foregroundPainter: new reticlePainter(lineColor: GlobalTheme().listAngleColor, width: 2.0))))
          ]);
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
      ..strokeWidth = 1;
    Path path = new Path();

    for (var i = 0.0; i < 301; i += 50) {
      path.moveTo(i, 0);
      path.relativeLineTo(0, -15);
    }
    for (var i = 0.0; i < 301; i += 5) {
      path.moveTo(i, 0);
      path.relativeLineTo(0, -4);
    }

    path.close();
    canvas.drawPath(path, complete);
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

    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(size.width / 2, -30);

    path.close();
    canvas.drawPath(path, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
