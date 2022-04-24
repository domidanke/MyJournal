import 'package:flutter/material.dart';

import '../models/custom_icons_icons.dart';

//region Maps/Lists

Map<String, IconData> kCategoryIconMapping = const {
  'Art': Icons.photo,
  'Beauty': Icons.face,
  'Dreams': Icons.airline_seat_flat,
  'Education': Icons.library_books,
  'Entertainment': Icons.tv,
  'Exercise': Icons.directions_run,
  'Friends': Icons.people,
  'Health': Icons.add_box,
  'Music': Icons.music_note,
  'Personal': Icons.edit,
  'Romance': Icons.favorite,
  'Travel': Icons.next_week,
};

List<IconData> kFeelingIcons = const [
  CustomIcons.angry,
  CustomIcons.sad,
  CustomIcons.meh,
  CustomIcons.smile_2,
  CustomIcons.happy,
];
//endregion

//region Functions
String formatDate(DateTime date) {
  return date.month.toString() +
      '-' +
      date.day.toString() +
      '-' +
      date.year.toString();
}

Color toColor(String colorString) {
  /// Colors are stored like this: 'Color(0x12345678)'
  try {
    final valueString = colorString.split('(0x')[1].split(')')[0];
    final value = int.parse(valueString, radix: 16);
    return Color(value);
  } catch (e) {
    return null;
  }
}
//endregion

//region Miscellaneous
Shader kGradient = LinearGradient(colors: [
  Colors.teal[100],
  Colors.teal[300],
  Colors.teal[500],
]).createShader(const Rect.fromLTWH(0, 0, 200.0, 70.0));

InputDecoration kTextFieldInputDecoration = const InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2.0), //color: Colors.teal[300],
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
//endregion
