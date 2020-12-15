import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({this.isLightTheme});

  bool isLightTheme;
}
