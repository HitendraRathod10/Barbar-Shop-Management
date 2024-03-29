import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_color.dart';
import '../utils/app_font.dart';

class TextFieldMixin {
  Widget textFieldWidget({TextEditingController? controller,
    Color? cursorColor,
    TextInputAction? textInputAction,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    void Function()? onTap,
    Widget? suffixIcon,
    InputBorder? border,
    Color? fillColor,
    int? maxLines = 1,
    int? maxLength,
    String? prefixText,
    String? counterText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    String? initialValue,
    bool readOnly = false,
    String? hintText,
    bool obscureText = false,
    InputBorder? focusedBorder,
    String? labelText,
    List<TextInputFormatter>? inputFormatters,
    TextStyle? labelStyle,
  }) {
    return TextFormField(
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 13,fontFamily: AppFont.regular),
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      maxLength: maxLength,
      minLines: 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          labelText: labelText,
          fillColor: AppColor.textFieldColor,
          labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5),fontFamily: AppFont.regular),
          hintText: hintText,
          counterText: counterText,
          hintStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5),fontSize: 13,fontFamily: AppFont.regular),
          prefixText: prefixText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.appColor.withOpacity(0.3)),borderRadius: BorderRadius.circular(10)),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.redColor.withOpacity(0.1)),borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.appColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(10)
          ),
          errorStyle: const TextStyle(
            fontSize: 12.0,fontFamily: AppFont.regular
          ),
        errorMaxLines: 4
      ),
    );
  }
}