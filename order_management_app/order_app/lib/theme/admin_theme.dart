// theme.dart
import 'package:flutter/material.dart';

final ThemeData adminTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color(0xFF6A1B9A),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.5,
    titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
    iconTheme: IconThemeData(color: Colors.black),
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
  ),

  hintColor: Colors.black54,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6A1B9A),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
      shadowColor: Colors.black12,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  ),

  cardTheme: const CardThemeData(
color: Colors.white,
elevation: 2,
shadowColor: Colors.black12,
surfaceTintColor: Colors.white, // optional for full white cards
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.all(Radius.circular(12)),
),
margin: EdgeInsets.all(8),
),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F5F5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    labelStyle: TextStyle(color: Colors.black),
    hintStyle: TextStyle(color: Colors.black54),
  ),

  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF5F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
  ),
);


