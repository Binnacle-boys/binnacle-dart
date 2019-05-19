import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sos/ui/global_theme.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';

class IdealHeadingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: IdeaHeadingStreamBuilder(context),
    );
  }
}

Widget IdeaHeadingStreamBuilder(BuildContext context) {
  Bloc bloc = Provider.of(context);
  return StreamBuilder(
      stream: bloc.listAngle,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return CircularProgressIndicator();
          return Stack(children: [
            new Center(
                child: Container(
                    height: 250.0, width: 250.0, child: new CustomPaint(foregroundPainter: new IdealHeadingArrowPainter(lineColor: Colors.green)))),
            new Center(
                child: Container(
                    height: 250.0,
                    width: 250.0,
                    child: new CustomPaint(foregroundPainter: new HeadingArrowPainter(lineColor: GlobalTheme().listAngleColor)))),
          ]);
        } else if (snapshot.hasError) {
          print("Stream error in list_angle_widget.dart -> listAngleStreamBuilder");
          return Text(' ');
        } else {
          return CircularProgressIndicator();
        }
      });
}

class HeadingArrowPainter extends CustomPainter {
  Color lineColor;

  double width = 4;

  HeadingArrowPainter({this.lineColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Path path = new Path();

    // path.moveTo(size.width / 2, size.height);
    // path.lineTo(size.width / 2, 0);
    // path.addPolygon([Offset(size.width / 2 + 5, 5), Offset(size.width / 2 - 5, 5), Offset(size.width / 2, -5)], true);
    path.moveTo(size.width / 2, size.height);
    path.lineTo(size.width / 2, 0);
    path.addPolygon([Offset(size.width / 2 + 5, 5), Offset(size.width / 2 - 5, 5), Offset(size.width / 2, -5)], true);

    path.close();
    canvas.drawPath(path, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class IdealHeadingArrowPainter extends CustomPainter {
  Color lineColor;

  double width = 30;

  IdealHeadingArrowPainter({this.lineColor});
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..strokeWidth = width;
    Path path = new Path();

    // path.moveTo(size.width / 2, size.height);
    // path.lineTo(size.width / 2, 0);
    // path.addPolygon([Offset(size.width / 2 + 5, 5), Offset(size.width / 2 - 5, 5), Offset(size.width / 2, -5)], true);
    Rect rect = new Rect.fromPoints(Offset(size.width / 2, size.height), Offset(size.width / 2, 15));
    //path.moveTo(size.width / 2, size.height);
    //path.lineTo(size.width / 2, 0);
    // path.addPolygon([Offset(size.width / 2 + 5, 5), Offset(size.width / 2 - 5, 5), Offset(size.width / 2, -5)], true);
    // path.addRect(rect);
    path.close();
    canvas.drawRect(rect, complete);
    canvas.drawPath(path, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
