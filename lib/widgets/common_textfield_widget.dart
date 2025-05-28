// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFieldWidget extends StatelessWidget {
  const CommonTextFieldWidget({
    super.key,
    this.hintText,
    this.textEditingController,
    this.onEditingComplete,
    this.obscureText,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.enabledBorder,
    this.prefix,
    this.onChanged,
    this.textCapitalization,
    this.formatter,
    this.maxLength,
    this.counterText,
    this.contentPadding,
    this.validator, // New parameter for custom validation
  });

  final String? hintText;
  final TextEditingController? textEditingController;
  final Function()? onEditingComplete;
  final bool? obscureText;
  final bool? readOnly;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final dynamic counterText;
  final InputBorder? enabledBorder;
  final Widget? prefix;
  final void Function(String)? onChanged;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? formatter;
  final EdgeInsetsGeometry? contentPadding;

  // Validator function to be passed for conditional validation
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      maxLength: maxLength,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      onTap: onTap,
      cursorColor: const Color(0xFF757575),
      style:  TextStyle(
                fontSize: 14,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.70),
                overflow: TextOverflow.visible),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: formatter,
      onChanged: onChanged,
      
      decoration: InputDecoration(
        contentPadding: contentPadding,
        counterText: counterText,
        enabledBorder: enabledBorder,
        hintText: hintText?.tr(),
        prefixIcon: prefix,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(
            suffixIcon,
            size: 25,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      // Using the validator passed from the parent widget
      validator: validator,
    );
  }
}
