import 'package:flutter/material.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

class PrimaryFormField extends StatelessWidget {
  final String validationError;
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final GestureTapCallback? onTap;
  final bool enabled;
  final String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? borderColor;
  final bool infiniteLines;
  final bool isValidate;
  final Function(String)? onChange;

  const PrimaryFormField({
    Key? key,
    required this.validationError,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.onTap,
    this.initialValue,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.borderColor,
    this.infiniteLines = false,
    this.isValidate = true,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      onTap: onTap,
      validator: isValidate
          ? (value) {
              if (value!.isEmpty) {
                return validationError;
              }
              return null;
            }
          : null,
      controller: controller,
      obscureText: isPassword,
      maxLines: infiniteLines ? null : 1,
      onChanged: onChange,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? borderGrey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderGrey,
          ),
        ),
      ),
    );
  }
}
