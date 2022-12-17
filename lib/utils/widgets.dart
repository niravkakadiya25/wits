import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

Widget buttonWidget(
    {required VoidCallback callback,
    required String text,
    double? radius,
    double? padding,
    Color color = Colors.black}) {
  return Container(
    child: TextButton(
      style: ButtonStyle(
        alignment: Alignment.center,
        backgroundColor: MaterialStateProperty.all(color),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: padding ?? 2.5),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12),
        )),
      ),
      onPressed: () => callback(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const Icon(
            Icons.navigate_next,
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}

buildErrorDialog(BuildContext context, String title, String contant,
    {VoidCallback? callback, String? buttonName}) {
  Widget okButton = TextButton(
    child: Text(buttonName ?? 'OK',
        style: const TextStyle(
          color: Colors.black,
          decorationColor: Colors.black,
        )),
    onPressed: () {
      if (callback == null) {
        Navigator.pop(context);
      } else {
        callback();
      }
    },
  );

  if (Platform.isAndroid) {
    AlertDialog alert = AlertDialog(
      title: Text(title,
          style: const TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      content: Text(contant,
          style: const TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  if (Platform.isIOS) {
    CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
      title: Text(title,
          style: const TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      content: Text(contant,
          style: const TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
  // show the dialog
}

Widget spinKit = Container(
  decoration: const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.elliptical(15.0, 15.0)),
    gradient: LinearGradient(
      begin: Alignment(-1.0, 1.0),
      end: Alignment(1.0, -1.0),
      colors: <Color>[
        Colors.grey,
        Colors.grey,
      ],
    ),
    // color: buttonColor,
  ),
  width: 90.0,
  height: 90.0,
  child: const SpinKitChasingDots(
    color: Colors.white,
    size: 40.0,
  ),
);

Widget commanScreen({required Scaffold scaffold, required bool isLoading}) {
  return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: spinKit,
        child: scaffold,
      ));
}
