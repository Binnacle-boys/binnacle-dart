import 'package:flutter/material.dart';
import 'DeckPainter.dart';

class DeckWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomPaint(
      painter: DeckPainter(),
      child: Container(height: 600),
    );
  }
}
