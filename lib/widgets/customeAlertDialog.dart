import 'package:flutter/material.dart';

Future<void> customeAlertDialog({required BuildContext context,required String title,required String content,bool isSuccess = true}) async {
  showDialog(context: context, builder: (context) => AlertDialog(
    backgroundColor: isSuccess ? Colors.green.shade200 : Colors.white,
    title: Text(title,style: TextStyle(color: isSuccess ? Colors.green : Colors.red),),
    content: Text(content),
    actions: [
      TextButton(
        child: const Text('Okay'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  ),);
}
