// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  ArrowPainter({this.color, this.percentChange});

  final Color color;
  final double percentChange;

  double width = 25.0;
  double height = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    paint.strokeWidth = 1.0;
    const double padding = 2.0;
    assert(padding >
        paint.strokeWidth / 2.0); // make sure the circle remains inside the box
    final double r =
        (size.shortestSide - padding) / 2.0; // radius of the circle
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
    path.moveTo(centerX, arrowY - height); // top of the arrow
    path.lineTo(centerX + width, arrowY + height);
    path.lineTo(centerX - width, arrowY + height);
    path.close();
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // Draw a circle that circumscribes the arrow.
    paint.style = PaintingStyle.stroke;
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

  int _colorIndexForPercentChange(double percentChange) {
    const double maxPercent = 10.0;
    final double normalizedPercentChange =
        math.min(percentChange.abs(), maxPercent) / maxPercent;
    return 100 + (normalizedPercentChange * 8.0).floor() * 100;
  }

  Color _colorForPercentChange(double percentChange) {
    return Colors.green[_colorIndexForPercentChange(percentChange)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.0,
        height: 40.0,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: CustomPaint(
            painter: ArrowPainter(
                color: _colorForPercentChange(percentChange),
                percentChange: percentChange)));
  }
}
