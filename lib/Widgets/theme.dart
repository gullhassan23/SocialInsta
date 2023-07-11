import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

class Mytheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.deepPurple,
      cardColor: Colors.white,
      canvasColor: creameColor,
      // buttonColor: bluish,
      // accentColor: bluish,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        // textTheme: Theme.of(context).textTheme,
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      cardColor: Colors.black,
      canvasColor: DarkcreameColor,
      // Color: lightbluish,
      // Color: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        // textTheme: Theme.of(context).textTheme,
      ));
  static Color creameColor = Color(0xfff5f5f5);

  static Color DarkcreameColor = Vx.gray900;
  static Color bluish = Color(0xff403b58);
  static Color smashColor = Color(0xffCDC9C9);
  static Color lightbluish = Vx.indigo500;
  static Color silver = Color(0xffC0C0C0);
  static Color whatsappTheme = Color(0xff075E54);
  static Color newInvent = Color(0xff0C2840);
  static Color accentColor = Color(0xff128C7E);
}
