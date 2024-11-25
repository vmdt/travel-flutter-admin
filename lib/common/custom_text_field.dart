import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_management/common/app_style.dart';
import 'package:travel_management/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      this.keyboardType,
      this.onEditingComplete,
      this.obscureText,
      this.suffixIcon,
      this.prefixIcon,
      this.validatior,
      this.hintText});

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validatior;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.h),
      padding: EdgeInsets.only(left: 6.h),
      decoration: BoxDecoration(
          border: Border.all(color: gray, width: 0.5),
          borderRadius: BorderRadius.circular(9.r)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        onEditingComplete: onEditingComplete,
        validator: validatior,
        cursorHeight: 30.h,
        style: appStyle(11, dark, FontWeight.normal),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: appStyle(11, dark, FontWeight.normal),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
