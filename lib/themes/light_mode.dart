import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4DD969), // Primary color
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF9C8DF2), // Primary color
    secondary: Color(0xFF9C8DF2), // Secondary color
    tertiary: Colors.grey, // Tertiary color (adjust as needed)
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    displayLarge: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Poppins'),
    bodyLarge: TextStyle(
        fontSize: 16, color: Colors.grey.shade400, fontFamily: 'Poppins'),
  ),
);
