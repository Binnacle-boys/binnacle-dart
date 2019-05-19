import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sos/ui/global_theme.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';

class BoomUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: boomStreamBuilder(context),
    );
  }
}

Widget boomStreamBuilder(BuildContext context) {
  Bloc bloc = Provider.of(context);
  return StreamBuilder(
      stream: bloc.idealBoom, //take(5).reduce((x,y) => BoomModel(x.angle + y.angle))),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
              child: Stack(children: <Widget>[
            new Center(
                child: new Transform.rotate(
                    // TODO still gittery
                    angle: (snapshot.data + pi),
                    child: Stack(children: <Widget>[
                      Container(
                          height: 50.0,
                          width: 50.0,
                          child: new CustomPaint(
                              foregroundPainter: new BoomMainLinePainter(
                            lineColor: GlobalTheme().boomColor,
                          ))),
                      new Container(
                          height: 50.0,
                          width: 50.0,
                          child: new CustomPaint(
                              foregroundPainter: new BoomArcPainter(
                            lineColor: GlobalTheme().boomColor,
                          )))
                    ])))
          ]));
        } else if (snapshot.hasError) {
          print("Stream error in list_angle_widget.dart -> boomStreamBuilder");
          return Text(' ');
        } else {
          return CircularProgressIndicator();
        }
      });
}

class BoomMainLinePainter extends CustomPainter {
  Color lineColor;

  double width = 4;
  double length = 223;

  BoomMainLinePainter({this.lineColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint completed = new Paint()
      ..color = Colors.grey[850]
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Path path_stroke = new Path();
    Offset cap = new Offset(size.width / 2, size.height / 2 + 40);

    canvas.drawCircle(cap, 0.001, completed);
    canvas.drawCircle(cap, 0.001, complete);
    path_stroke.moveTo(size.width / 2, size.height / 2 + 40);

    //path_stroke.lineTo(size.width / 2, size.height / 2 + 15);
    path_stroke.lineTo(size.width / 2, length);
    path_stroke.close();

    canvas.drawPath(path_stroke, completed);
    Path path = new Path();
    Offset capOuter = new Offset(size.width / 2, length);
    path.moveTo(size.width / 2, size.height / 2 + 40);

    // path.lineTo(size.width / 2, size.height / 2 + 15);
    path.lineTo(size.width / 2, length);
    path.close();
    canvas.drawPath(path, complete);

    canvas.drawCircle(capOuter, 0.001, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BoomArcPainter extends CustomPainter {
  Color lineColor;

  double width = 4;
  double length = 220;

  BoomArcPainter({this.lineColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Path path = new Path();
    Offset cap = new Offset(size.width / 2, size.height / 2);
    Offset capOuter = new Offset(size.width / 2, length);
    // path.moveTo(size.width / 2, size.height / 2 - 15);

    // path.lineTo(size.width / 2, size.height / 2 - 15);
    // path.lineTo(size.width / 2, length);
    Rect arcContainer = new Rect.fromCircle(center: cap, radius: 200);

    // path.addArc(arcContainer, 0, pi);
    // path.close();
    canvas.drawArc(arcContainer, 298 * pi / 120, pi / 30, false, complete);
    //canvas.drawCircle(cap, 0.001, complete);
    //canvas.drawCircle(capOuter, 0.001, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
