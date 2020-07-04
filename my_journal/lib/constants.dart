import 'package:flutter/material.dart';

const Color kPink = Color(0xffefabc5);
Shader headerGradient =
    const LinearGradient(colors: [Color(0xff5f2c82), Color(0xff49a09d)])
        .createShader(const Rect.fromLTWH(0, 0, 200.0, 70.0));

const kCardDecoration = BoxDecoration(
  gradient:
      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          //colors: [Color(0xffd7d0f5), Color(0xff9385d6)]),
          colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
);

const InputDecoration kTextFieldInputDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff49a09d), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPink, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
