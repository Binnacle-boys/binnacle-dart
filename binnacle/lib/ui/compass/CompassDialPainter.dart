import 'dart:math';

import 'package:flutter/material.dart';

class CompassDialPainter extends CustomPainter {
  // Varying stroke dimensions to indicate
  // Cardinal directions
  final double degreeTickLength = 5.0;
  final double cardinalTickLength = 10.0;

  final double degreeTickMarkWidth = 1.0;
  final double cardinalTickMarkWidth = 2.0;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final cardinalDirections = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  final int numberOfTicks = 72;
  // Every 5 degrees a tick: 360/5
  // no clean 45 degree mark for minutes
  double angle;
  double cardinalInterval;

  CompassDialPainter({ThemeData td})
      : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle = td.textTheme.body1 {
    tickPaint.color = td.primaryColor;
    angle = 2 * pi / numberOfTicks;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double tickMarkLength;
    var radius = size.width / 2;
    canvas.save();

    int numberOfCardinals = cardinalDirections.length;
    // Floor to prevent errors
    int cardinalUnit = (numberOfTicks / numberOfCardinals).floor();

    // drawing
    canvas.translate(radius, radius);
    for (var i = 0; i < numberOfTicks; i++) {
      //make the length and stroke of the tick marker longer and thicker depending
      if (i % cardinalUnit == 0) {
        // it's a cardinal direction (N, NE, .. etc.)
        tickMarkLength = cardinalTickLength;
        tickPaint.strokeWidth = cardinalTickMarkWidth;
      } else {
        tickMarkLength = degreeTickLength;
        tickPaint.strokeWidth = degreeTickMarkWidth;
      }
      canvas.drawLine(new Offset(0.0, -radius),
          new Offset(0.0, -radius + tickMarkLength), tickPaint);

      // draw the text
      if (i % cardinalUnit == 0) {
        canvas.save();
        canvas.translate(0.0, -radius + 20.0);
        textPainter.text = new TextSpan(
          text: '${cardinalDirections[i ~/ numberOfCardinals]}',
          style: textStyle,
        );

        //helps make the text painted vertically

        textPainter.layout();

        textPainter.paint(canvas,
            new Offset(-(textPainter.width / 2), -(textPainter.height / 2)));

        canvas.restore();
      }
      // Rotate for next tick
      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
