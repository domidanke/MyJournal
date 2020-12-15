import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiniImage extends StatelessWidget {
  const MiniImage({this.image});
  final Image image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.0,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: image,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}
