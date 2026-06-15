import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Text textRegularPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 14.sp,
      fontFamily: "Poppins",
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Text textSemiBoldPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 14.sp,
      fontFamily: "Poppins",
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color,
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Text textBoldPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 14.sp,
      fontFamily: "Poppins",
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Color.fromRGBO(0, 0, 0, 1),
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Text textRegularMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 14.sp,
      fontFamily: "Montserrat",
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Text textHeadingMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 24.sp,
      fontFamily: "Montserrat",
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Text textSemiBoldMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
    int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 15.sp,
      fontFamily: "Montserrat",
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Color.fromRGBO(0, 0, 0, 1),
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}

Text textBoldMontserrat(
    {required String text,
      Color? color,
      FontWeight? fontWeight,
      double? fontSize,
      TextOverflow? textOverflow,
      TextDecoration? decoration,
      FontStyle? fontStyle,
      int? maxLines,
      TextAlign? textAlign,
      bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 14.sp,
      fontFamily: "Montserrat",
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Color.fromRGBO(0, 0, 0, 1),
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines: maxLines,
  );
}
