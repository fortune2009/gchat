import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FWt {
  FWt();

  static FontWeight extraLight = FontWeight.w200;
  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight semiBold = FontWeight.w500;
  static FontWeight mediumBold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
  static FontWeight text = FontWeight.w900;
}

class Styles {
  static Text largeBoldTextStyle(
    String text, {
    double? fontSize,
    Color? color,
    TextAlign? align,
    double? height,
    FontStyle? fontStyle,
    String? fontFamily,
    FontWeight? fontWeight,
    bool strike = false,
    int? lines,
    TextOverflow? overflow,
    bool underline = false,
  }) =>
      Text(
        text,
        textAlign: align ?? TextAlign.left,
        maxLines: lines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize ?? 28.0,
          fontWeight: fontWeight ?? FWt.text,
          color: color,
          height: height,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
          decoration: underline
              ? TextDecoration.underline
              : strike
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );

  static Text boldTextStyle(
    String text, {
    double? fontSize,
    Color? color,
    TextAlign? align,
    double? height,
    FontStyle? fontStyle,
    String? fontFamily,
    FontWeight? fontWeight,
    bool strike = false,
    int? lines,
    TextOverflow? overflow,
    bool underline = false,
  }) =>
      Text(
        text,
        textAlign: align ?? TextAlign.left,
        maxLines: lines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize ?? 24.0,
          fontWeight: fontWeight ?? FWt.bold,
          color: color,
          height: height,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
          decoration: underline
              ? TextDecoration.underline
              : strike
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );

  static Text semiBoldTextStyle(
    String text, {
    double? fontSize,
    Color? color,
    TextAlign? align,
    double? height,
    FontStyle? fontStyle,
    String? fontFamily,
    FontWeight? fontWeight,
    bool strike = false,
    int? lines,
    TextOverflow? overflow,
    bool underline = false,
  }) =>
      Text(
        text,
        textAlign: align ?? TextAlign.left,
        maxLines: lines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize ?? 18.0,
          fontWeight: fontWeight ?? FWt.semiBold,
          color: color,
          height: height,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
          decoration: underline
              ? TextDecoration.underline
              : strike
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );

  static Text mediumTextStyle(
    String text, {
    double? fontSize,
    Color? color,
    TextAlign? align,
    double? height,
    FontStyle? fontStyle,
    String? fontFamily,
    FontWeight? fontWeight,
    bool strike = false,
    int? lines,
    TextOverflow? overflow,
    bool underline = false,
  }) =>
      Text(
        text,
        textAlign: align ?? TextAlign.left,
        maxLines: lines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize ?? 16.0,
          fontWeight: fontWeight ?? FWt.mediumBold,
          color: color,
          height: height,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
          decoration: underline
              ? TextDecoration.underline
              : strike
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );

  static Text regularTextStyle(
    String text, {
    double? fontSize,
    Color? color,
    TextAlign? align,
    double? height,
    FontStyle? fontStyle,
    String? fontFamily,
    FontWeight? fontWeight,
    bool strike = false,
    int? lines,
    TextOverflow? overflow,
    bool underline = false,
  }) =>
      Text(
        text,
        textAlign: align ?? TextAlign.left,
        maxLines: lines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize ?? 14.0,
          fontWeight: fontWeight ?? FWt.regular,
          color: color,
          height: height,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
          decoration: underline
              ? TextDecoration.underline
              : strike
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );

  static TextSpan spanRegular(
    String text, {
    double? fontSize,
    Color? color,
    TextAlign? align,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    bool strike = false,
    int? lines,
    TextOverflow? overflow,
    bool underline = false,
    Function()? recognizer,
  }) {
    return TextSpan(
      text: text,
      recognizer: TapGestureRecognizer()..onTap = recognizer,
      style: TextStyle(
        fontSize: fontSize ?? 14.0,
        fontWeight: fontWeight ?? FWt.regular,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
        fontFamily: 'Roboto',
        decoration: underline
            ? TextDecoration.underline
            : strike
                ? TextDecoration.lineThrough
                : TextDecoration.none,
      ),
    );
  }
}
