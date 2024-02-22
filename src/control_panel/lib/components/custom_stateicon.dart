import 'package:flutter/material.dart';

/// Defines a custom icon to represent the state of a device or service
class StateIcon extends StatelessWidget {
  final bool isOn;
  const StateIcon({super.key, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: isOn ? Colors.green : Colors.red,
        width: 20,
        height: 20,
      ),
    );
  }
}
