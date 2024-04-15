import 'package:control_panel/components/custom_stateicon.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function onPressed;
  final bool isToggled;
  final String startText;
  final String stopText;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.isToggled,
    required this.startText,
    required this.stopText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isToggled ? stopText : startText,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          StateIcon(isOn: isToggled),
        ],
      ),
    );
  }
}
