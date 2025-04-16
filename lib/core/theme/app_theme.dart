import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.grey.shade300,
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 9, 9, 9),
    primary: Color.fromARGB(255, 105, 105, 105),
    secondary: Color.fromARGB(255, 20, 20, 20),
    tertiary: Color.fromARGB(255, 29, 29, 29),
    inversePrimary: Color.fromARGB(255, 195, 195, 195),
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 9, 9, 9),
);
