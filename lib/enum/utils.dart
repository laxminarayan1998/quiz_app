import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {
  static void showToast({String msg = "Please wait..."}) {
    Fluttertoast.showToast(
      gravity: ToastGravity.CENTER,
      msg: msg,
      backgroundColor: Colors.black,
    );
  }
}
