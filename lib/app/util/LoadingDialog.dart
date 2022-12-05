import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, String content) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          color: Color(0xffffffff),
          height: 100,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: new Text(
                  content,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
