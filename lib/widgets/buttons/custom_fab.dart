import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({@required this.childButtons, this.onOpen, this.onClose});
  final List<SpeedDialChild> childButtons;
  final Function onOpen;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 24.0),
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => onOpen,
      onClose: () => onClose,
      //backgroundColor: Colors.teal[300],
      elevation: 8.0,
      children: childButtons,
    );
  }
}
