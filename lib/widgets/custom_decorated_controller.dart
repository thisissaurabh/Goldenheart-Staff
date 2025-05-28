import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/dimensions.dart';



class CustomDecoratedContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? horizontalPadding;
  final double? verticalPadding;
    final double? radius;
  final Function()?  tap;
  const CustomDecoratedContainer({super.key, required this.child, this.color, this.horizontalPadding, this.verticalPadding,  this.tap, this.radius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(padding:
      EdgeInsets.symmetric(horizontal: horizontalPadding ?? 3,vertical: verticalPadding ?? 0),
      decoration: BoxDecoration(
      color: color ?? Theme.of(context)
          .dividerColor
          .withOpacity(0.90),
      borderRadius: BorderRadius.circular(radius??
      Dimensions.radius20),
      ),
        child: child,
      ),
    );
  }
}
