// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sos/ui/global_theme.dart';

class ArrowPainter extends CustomPainter {
  var theme;

  ArrowPainter({this.percentChange});

  final double percentChange;

  double width = 15.0;
  double height = 10.25;

  @override
  void paint(Canvas canvas, Size size) {
    theme = GlobalTheme();
    final Paint paint = Paint()..color = theme.windArrowColor;
    paint.strokeWidth = 4.0;
    const double padding = 2.0;
    assert(padding > paint.strokeWidth / 4.0); // make sure the circle remains inside the box
    final double r = (size.shortestSide - padding) / 2.0; // radius of the circle
    final double centerX = padding + r;
    final double centerY = padding + r;

    // Draw the arrow.
    double arrowY;
    if (percentChange < 0.0) {
      height = -height;
      arrowY = centerX + 1.0;
    } else {
      arrowY = centerX - 1.0;
    }
    final Path path = Path();

    var len = 110;
    path.moveTo(centerX, arrowY - height - 4); // top of the arrow
    path.lineTo(centerX + width, arrowY + height);
    path.lineTo(centerX + width - 7, arrowY + height + len);
    path.lineTo(centerX - width + 7, arrowY + height + len);
    path.lineTo(centerX - width, arrowY + height);
    path.close();
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    paint.color = theme.backgroundColor;
    paint.strokeWidth = 10;
    canvas.drawPath(path, paint);

    // paint.style = PaintingStyle.fill;
    paint.style = PaintingStyle.fill;

    paint.color = theme.windArrowColor;
    canvas.drawPath(path, paint);
    // Draw a circle that circumscribes the arrow.

    canvas.drawCircle(Offset(centerX, centerY), r, paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return true;
  }
}

class StockArrow extends StatelessWidget {
  const StockArrow({Key key, this.percentChange}) : super(key: key);

  final double percentChange;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.0,
        height: 40.0,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: CustomPaint(painter: ArrowPainter(percentChange: percentChange)));
  }
}

class ArrowPainter2 extends CustomPainter {
  var theme;

  double width = 15.0;
  double height = 10.25;

  @override
  void paint(Canvas canvas, Size size) {
    theme = GlobalTheme();
    final Paint paint = Paint()..color = theme.windArrowColor;
    paint.strokeWidth = 4.0;
    const double padding = 2.0;
    assert(padding > paint.strokeWidth / 4.0); // make sure the circle remains inside the box
    final double r = (size.shortestSide - padding) / 2.0; // radius of the circle
    final double centerX = padding + r;
    final double centerY = padding + r;

    // Draw the arrow.
    double arrowY;
    if (0 < 0.0) {
      height = -height;
      arrowY = centerX + 1.0;
    } else {
      arrowY = centerX - 1.0;
    }
    final Path path = Path();

    var len = 110;
    path.moveTo(centerX, arrowY - height - 4); // top of the arrow
    path.lineTo(centerX + width, arrowY + height);
    path.lineTo(centerX + width - 7, arrowY + height + len);
    path.lineTo(centerX - width + 7, arrowY + height + len);
    path.lineTo(centerX - width, arrowY + height);
    path.close();

    paint.style = PaintingStyle.stroke;

    paint.color = theme.backgroundColor;
    paint.strokeWidth = 10;
    canvas.drawPath(path, paint);

    // paint.style = PaintingStyle.fill;
    paint.style = PaintingStyle.fill;

    paint.color = theme.accentColor;
    canvas.drawPath(path, paint);
    // Draw a circle that circumscribes the arrow.

    canvas.drawCircle(Offset(centerX, centerY), r, paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return true;
  }
}
