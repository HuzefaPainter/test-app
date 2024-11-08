import 'package:employee_app/ui_helpers/constants.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(context, String toastMessage, int seconds,
      {Widget? endWidget}) {
    try {
      //Remove current ensures there isn't a long list of snackbars showing up
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: Container(
            decoration: const BoxDecoration(color: ALMOST_BLACK),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    toastMessage,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                endWidget ?? const SizedBox.shrink()
              ],
            ),
          ),
          duration: Duration(seconds: seconds),
        ));
      // ignore: empty_catches
    } catch (e) {}
  }
}
