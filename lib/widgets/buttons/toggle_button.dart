import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton(
      {this.toggle,
      this.color,
      this.firstText,
      this.secondText,
      this.onPressed});
  final bool toggle;
  final Color color;
  final String firstText;
  final String secondText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: toggle
          ? FlatButton(
              key: const Key('firstButton'),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: color),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(firstText),
              onPressed: onPressed)
          : FlatButton(
              key: const Key('secondButton'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Text(
                'Oldest',
                style: TextStyle(color: Colors.white),
              ),
              color: color,
              onPressed: onPressed),
    );
  }
}
