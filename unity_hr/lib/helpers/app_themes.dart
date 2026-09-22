import 'package:flutter/material.dart';
import 'package:unity_hr/helpers/constants.dart';

class AppThemes {
  static Color lightPrimary = color1;
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: createMaterialColor(color1),
    appBarTheme: AppBarTheme(backgroundColor: color1),
    iconTheme: IconThemeData(color: color1),
    listTileTheme: ListTileThemeData(iconColor: color1),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(side: BorderSide(color: color1)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.w500,
        fontFamily: 'SFPRODISPLAYMEDIUM',
      ),
      headlineMedium: TextStyle(fontFamily: 'SFPRODISPLAYMEDIUM'),
      titleLarge: TextStyle(fontFamily: 'SFPRODISPLAYBOLD'),
    ),
    fontFamily: 'SFPRODISPLAYREGULAR',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: color1,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        // ),
        shadowColor: WidgetStateProperty.all(Colors.black),
        elevation: WidgetStateProperty.all(10),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          // If the button is pressed, return green, otherwise red
          if (states.contains(WidgetState.pressed)) {
            return Colors.green;
          }
          return color1;
        }),
      ),
    ),
    buttonTheme: ButtonThemeData(buttonColor: color1),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.grey.withValues(alpha: 0.8),
    blurRadius: 8.0,
    spreadRadius: 0.0,
    offset: const Offset(0.0, 2.0),
  );
}
