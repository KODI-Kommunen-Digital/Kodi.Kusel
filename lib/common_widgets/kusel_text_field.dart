import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/theme_manager/theme_manager_controller.dart';

class KuselTextField extends ConsumerStatefulWidget {
  TextEditingController textEditingController;
  TextInputType? keyboardType;
  Color? textColor;
  Color? fillColor;
  void Function(String value)? onChanged;
  Color? hintTextColor;
  Color? focusBorderColor;
  Color? enableBorderColor;
  Color? errorBorderColor;
  Color? focusedErrorBorder;
  Color? errorStyleColor;
  Color? borderColor;
  bool? enable;
  String? hintText;
  String? Function(String?)? validator;
  Widget? suffixIcon;
  bool? readOnly;
  int? maxLines;
  EdgeInsetsGeometry? contentPadding;
  bool? obscureText;
  bool outlined;
  List<TextInputFormatter>? inputFormatters;
  void Function(String)? onFieldSubmitted;
  FocusNode? focusNode;
  TextAlign? textAlign;
  final List<String>? autofillHints;
  Function()? onTap;
  int? maxLength;
  Widget? prefixIcon;

  KuselTextField(
      {required this.textEditingController,
      this.textColor,
      this.fillColor,
      this.hintTextColor,
      this.focusBorderColor,
      this.enableBorderColor,
      this.keyboardType,
      this.errorBorderColor,
      this.focusedErrorBorder,
      this.errorStyleColor,
      this.onChanged,
      this.enable,
      this.hintText,
      this.validator,
      this.borderColor,
      this.suffixIcon,
      this.readOnly,
      this.maxLines,
      this.contentPadding,
      this.obscureText,
      this.outlined = false,
      this.inputFormatters,
      this.onFieldSubmitted,
      this.focusNode,
      this.textAlign,
      this.autofillHints,
        this.maxLength,
        this.onTap,
        this.prefixIcon,
      super.key});

  @override
  ConsumerState<KuselTextField> createState() => _KuselTextFieldState();
}

class _KuselTextFieldState extends ConsumerState<KuselTextField> {
  @override
  Widget build(BuildContext context) {
    final currentSelectedThemeData =
        ref.watch(themeManagerProvider).currentSelectedTheme!;

    double borderRadius = 20.r;

    return TextFormField(
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      textAlign: widget.textAlign ?? TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText ?? false,
      maxLines: (widget.obscureText ?? false) ? 1 : widget.maxLines, // ✅ Fix
      minLines: (widget.obscureText ?? false) ? 1 : null, // ✅ Add
      validator: widget.validator,
      enabled: widget.enable ?? true,
      readOnly: widget.readOnly ?? false,
      controller: widget.textEditingController,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints,
      style: TextStyle(
        fontSize:  14.sp,
        fontFamily: "Montserrat",
        fontWeight:  FontWeight.w400,
        color: Theme.of(context).textTheme.displayMedium!.color!,
      ),
      decoration: InputDecoration(
          errorMaxLines: 3, // ✅ Add this
          prefixIconConstraints: BoxConstraints(
            maxHeight: 44.h,
            maxWidth: 44.w
          ),
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(left: 12.w,right: 6.w),
            child: widget.prefixIcon,
          ),
          filled: true,
          suffixIconConstraints:
          BoxConstraints(maxWidth: 40.w, maxHeight: 40.h),
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.8), width: 2)),
          hintText: widget.hintText,
          contentPadding:
              widget.contentPadding ?? EdgeInsets.only(top: 20.h, left: 10.w),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
                color: widget.focusBorderColor ?? Colors.transparent,
                width: 0.7),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: widget.enableBorderColor ??
                      Color.fromRGBO(255, 255, 255, 0.8))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: widget.errorBorderColor ?? Colors.red, width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: widget.focusedErrorBorder ?? Colors.red, width: 1)),
          errorStyle: TextStyle(
            color: widget.errorStyleColor ?? Colors.red,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.visible,
            fontSize: 11,
            height: 1.3, // ✅ Add line height
          ),
          hintStyle: TextStyle(
            fontSize:  16.sp,
            fontFamily: "Montserrat",
            fontWeight:  FontWeight.w400,
            color: Theme.of(context).textTheme.displayMedium!.color!.withOpacity(0.5),
          )),
    );
  }

}
