import 'package:flutter/material.dart';
import 'package:gchat/constants/color_constants.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput(
      {super.key,
      this.controller,
      this.obscureText = false,
      this.hintText,
      this.onChanged,
      this.textInputAction,
      this.validator});
  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: ColorConstants.textGreyColor,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: ColorConstants.borderGreyColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      validator: validator,
    );
  }
}
