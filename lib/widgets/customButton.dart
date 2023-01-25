import 'package:flutter/material.dart';

Widget customButton({
  required VoidCallback onClick,
  IconData? icon,
  required String title,
}) {
  return InkWell(
    onTap: onClick,
    child: Container(
      padding: EdgeInsets.all(12),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black45,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title), Icon(icon)],
      ),
    ),
  );
}
