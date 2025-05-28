

import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utils/dimensions.dart';
import '../utils/textstyles.dart';


class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final IconData? suffixIcon; // New suffixIcon parameter
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final bool isLoading;
  final bool isBold;
  final Color? borderSideColor;

  const CustomButtonWidget({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 10,
    this.icon,
    this.suffixIcon, // Initialize suffixIcon
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isBold = true,
    this.borderSideColor, this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).primaryColor
          : transparent
          ? Colors.transparent
          : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width ?? Dimensions.webMaxWidth, height ?? 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: borderSideColor ?? Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );

    return Center(
      child: SizedBox(
        width: width ?? Dimensions.webMaxWidth,
        child: Padding(
          padding: margin ?? const EdgeInsets.all(0),
          child: TextButton(
            onPressed: isLoading ? null : onPressed as void Function()?,
            style: flatButtonStyle,
            child: isLoading
                ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSize10),
                  Text('Loading', style: openSansMedium.copyWith(color: Colors.white)),
                ],
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Icon(
                      icon,
                      color: iconColor?? Theme.of(context).dividerColor,

                      size: Dimensions.fontSizeDefault,
                    ),
                  ),
                if (icon != null) sizedBoxW5(),
                Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: isBold
                      ? openSansBold.copyWith(
                    color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
                    fontSize: fontSize ?? Dimensions.fontSize18,
                  )
                      : openSansRegular.copyWith(
                    color: textColor ?? (transparent ? Theme.of(context).primaryColor : Colors.white),
                    fontSize: fontSize ?? Dimensions.fontSize18,
                  ),
                ).tr(),
                if (suffixIcon != null) sizedBoxW5(), // Add spacing before suffix icon
                if (suffixIcon != null)
                  Icon(
                    suffixIcon,
                    color: Theme.of(context).primaryColor,
                    size: Dimensions.fontSizeDefault,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
