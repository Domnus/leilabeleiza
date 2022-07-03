import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final mainTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xff810fcc),
    secondary: Color(0xffffffff),
    error: Color(0xff810fcc),
    background: Color(0xff810fcc),
    onPrimary: Colors.white,
    onError: Color(0xff810fcc),
    onSecondary: Color(0xff810fcc),
    onSurface: Color(0xff810fcc),
    surface: Color(0xff810fcc),
    brightness: Brightness.dark,
    onBackground: Color(0xff810fcc),
  ),
  dialogBackgroundColor: Colors.white,
  textTheme: GoogleFonts.quicksandTextTheme(),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Colors.white,
    dialHandColor: Colors.white,
    dialTextColor: Color(0xff810fcc),
  ),
);