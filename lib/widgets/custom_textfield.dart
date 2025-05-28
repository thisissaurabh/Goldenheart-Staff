import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/dimensions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../utils/textstyles.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final String? prefixImage;
  final IconData? prefixIcon;
  final bool divider;
  final bool showTitle;
  final bool isAmount;
  final bool isNumber;
  final bool isPhone;
  final String? countryDialCode;
  final bool showBorder;
  final double iconSize;
  final bool isRequired;
  final bool readOnly;
  final bool editText; // Property to show edit text suffix
  final FormFieldValidator<String>? validation;
  final Function()? onTap;
  final bool isCalenderIcon; // New property for calendar icon
  final bool isClockIcon; // New property for clock icon
  final int? maxLength; // Property for max character limit
  final String? suffixText;
  final Function(String)? onCountryCodeChanged;
  final double? fontSize;

  const CustomTextField({
    super.key,
    this.hintText = 'Write something...',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.prefixImage,
    this.prefixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.divider = false,
    this.showTitle = false,
    this.isAmount = false,
    this.isNumber = false,
    this.isPhone = false,
    this.countryDialCode,
    this.showBorder = true,
    this.iconSize = 18,
    this.isRequired = false,
    this.readOnly = false,
    this.editText = false,
    this.validation,
    this.onTap,
    this.isCalenderIcon = false,
    this.isClockIcon = false, // Initialize the new property
    this.maxLength,
    this.suffixText,
    this.onCountryCodeChanged,
    this.fontSize,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showTitle
            ? Text(
                widget.hintText,
                style: openSansRegular.copyWith(
                    fontSize: Dimensions.fontSize12,
                    color:
                        Theme.of(context).hintColor), // Adjust style as needed
              ).tr()
            : const SizedBox(),
        SizedBox(height: widget.showTitle ? 5 : 0),
        TextFormField(
          onTap: widget.onTap,
          validator: widget.validation,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: openSansRegular.copyWith(
              fontSize: widget.fontSize ?? 13), // Adjust text style as needed
          textInputAction: widget.inputAction,
          keyboardType:
              widget.isAmount ? TextInputType.number : widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          autofocus: false,
          minLines: widget.maxLines,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: widget.isAmount
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
              : widget.isNumber
                  ? [
                      FilteringTextInputFormatter.allow(RegExp(r'\d')),
                      LengthLimitingTextInputFormatter(widget.maxLength ?? 10),
                    ]
                  : widget.isPhone
                      ? [FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
                      : null,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 0.3,
                color: Theme.of(context).primaryColorDark.withOpacity(0.80),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                style: widget.showBorder ? BorderStyle.solid : BorderStyle.none,
                width: 0.3,
                color: Theme.of(context).primaryColorDark.withOpacity(0.80),
              ),
            ),
            isDense: true,
            hintText: widget.hintText,
            errorStyle: openSansRegular.copyWith(
                fontSize: Dimensions.fontSize12, color: Colors.red),
            fillColor: Theme.of(context).cardColor,
            hintStyle: openSansRegular.copyWith(
                fontSize: Dimensions.fontSize14,
                color: Theme.of(context).dividerColor),
            filled: true,
            prefixIcon: widget.isPhone
                ?
                // SizedBox(
                //     child: CountryCodePicker(
                //       onChanged: (countryCode) {
                //         widget.onCountryCodeChanged!(countryCode.dialCode!);
                //       },
                //       initialSelection: 'IN',
                //       favorite: const ['+91', 'IN'], // Favorites
                //       showCountryOnly: false,
                //       showOnlyCountryWhenClosed: false,
                //       alignLeft: false,
                //       textStyle:
                //           TextStyle(color: Theme.of(context).dividerColor),
                //     ),
                //   )
                SizedBox(
                    width: 55,
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          " + 91",
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 20,
                          width: 0.5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  )
                : widget.prefixImage != null && widget.prefixIcon == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          widget.prefixImage!,
                          height: 20,
                          width: 20,
                        ),
                      )
                    : widget.prefixImage == null && widget.prefixIcon != null
                        ? Icon(
                            widget.prefixIcon,
                            size: widget.iconSize,
                          )
                        : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: _toggle,
                  )
                : widget.isCalenderIcon
                    ? GestureDetector(
                        onTap: () {
                          // Add calendar functionality here, like opening a date picker
                        },
                        child: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : widget.isClockIcon
                        ? GestureDetector(
                            onTap: () {
                              // Add clock functionality here, like opening a time picker
                            },
                            child: Icon(
                              Icons.access_time,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : widget.editText
                            ? Container(
                                width: 60,
                                child: Center(
                                    child: Text(widget.suffixText ?? 'mg/dL')),
                              )
                            : null,
          ),
          onChanged: widget.onChanged as void Function(String)?,
        ),
        widget.divider
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              )
            : const SizedBox(),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
