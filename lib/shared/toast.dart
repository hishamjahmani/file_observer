import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

toast(String msg) {
  toastification.show(
    title:  Text(msg),
    autoCloseDuration: const Duration(milliseconds: 1750),
    applyBlurEffect: true,
    backgroundColor: Colors.lightGreen,
    alignment: Alignment.bottomCenter,
    animationDuration: const Duration(milliseconds: 700),
  );
}
