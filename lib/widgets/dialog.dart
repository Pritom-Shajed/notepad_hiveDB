import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget alert({
  required String title,
  required VoidCallback onClickYes,
  required VoidCallback onClickNo,
}) {
  return CupertinoAlertDialog(
    title: Text(title),
    actions: [
      TextButton(onPressed: onClickYes, child: Text('Yes')),
      TextButton(onPressed: onClickNo, child: Text('No')),
    ],
  );
}
