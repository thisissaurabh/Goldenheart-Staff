//flutter
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CommonDropDown extends StatelessWidget {
  final Widget? hint;
  final VoidCallback? voidCallback;
  final void Function()? onTap;
  final List<dynamic>? list;
  final void Function(dynamic)? onChanged;
  final dynamic type;
  final dynamic val;
  final double? height;
  final double? width;
  const CommonDropDown({
    super.key,
    this.voidCallback,
    this.type,
    this.onChanged,
    this.hint,
    this.onTap,
    this.val,
    this.list,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).dividerColor,
      ),
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          color: Colors.black,
          overflow: TextOverflow.visible),
      items: list!.map<DropdownMenuItem>((dynamic value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(
                fontSize: 14,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.70),
                overflow: TextOverflow.visible),
          ),
        );
      }).toList(),
      value: val,
      hint: hint,
      onTap: onTap,
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
