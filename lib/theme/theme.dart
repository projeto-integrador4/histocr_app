import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

const colorSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: textColor,
  secondary: secondaryColor,
  onSecondary: textColor,
  tertiary: accentColor,
  onTertiary: white,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.light == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);

final textInputDecoration = InputDecorationTheme(
  filled: true,
  fillColor: white,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide.none,
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide.none,
  ),
  enabledBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide.none,
  ),
  errorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide.none,
  ),
  hintStyle: TextStyle(
    color: textColor.withOpacity(0.5),
  ),
  focusColor: white,
  hoverColor: white,
);
