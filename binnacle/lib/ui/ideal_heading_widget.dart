import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sos/models/compass_model.dart';
import 'package:sos/ui/global_theme.dart';
import '../bloc.dart';
import '../providers/app_provider.dart';

class IdealHeadingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc bloc = Provider.of(context);
    return StreamBuilder(
        stream: bloc.compass,
        builder: (context, AsyncSnapshot<CompassModel> snapshot) {
          if (snapshot.hasData) {
            // return CircularProgressIndicator();
            return Stack(children: [
              new Transform.rotate(
                  //TODO just hooked up to heading stream for now bc ideal heading doesnt exist
                  angle: (snapshot.data.direction * pi / 180),
                  child: new Align(
                    alignment: Alignment.center,
                    child: CustomPaint(painter: IdealHeadingArrowPainter(superContext: context)),
                  )),
              new Container(alignment: Alignment.center, child: CustomPaint(painter: HeadingArrowPainter(superContext: context))),
            ]);
          } else if (snapshot.hasError) {
            print("Stream error in list_angle_widget.dart -> listAngleStreamBuilder");
            return Text(' ');
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class HeadingArrowPainter extends CustomPainter {
  Color lineColor;

  double width = 5;
  BuildContext superContext;
  var w, h;

  HeadingArrowPainter({this.superContext});


  // NOTE: This seems to be the real heading
  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = new Paint()
      ..color = Colors.lightBlue[200]
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Path path = new Path();
    w = superContext.size.width;
    h = superContext.size.height;
    path.moveTo(0, -130);
    path.lineTo(0, 140);
    path.addPolygon([Offset(3, -130), Offset(0, -135), Offset(-3, -130)], true);
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

  double width = 0;
  BuildContext superContext;

  IdealHeadingArrowPainter({this.superContext});
  @override
  void paint(Canvas canvas, Size size) {
    var theme = GlobalTheme();
    Paint complete = new Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
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

    // Outline of ideal heading arrow
    complete.color = Colors.blue[800];
    complete.strokeWidth = 5;
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
