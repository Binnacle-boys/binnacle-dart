import 'package:flutter/material.dart';

class SpeedWidget extends StatelessWidget {
  
  // Final because this is a StatelessWidget,
  // So this Widget should not alter state
  
  // Constructor
  final String speed; 
  SpeedWidget(this.speed);

  @override
  Widget build(BuildContext context) {
    return Text(speed);
  }
}
