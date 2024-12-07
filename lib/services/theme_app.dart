import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(
    color: Colors.blue,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Sử dụng TextStyle
    bodyMedium: TextStyle(color: Colors.black54),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blueGrey,
  appBarTheme: AppBarTheme(
    color: Colors.grey[900],
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);