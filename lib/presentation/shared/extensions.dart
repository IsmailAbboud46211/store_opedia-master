import 'package:flutter/material.dart';

extension ExtendedNavigator on BuildContext {
  Future<dynamic> push(Widget page) async {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic> pushRepalceme(Widget page) async {
    return Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic> pop([result]) async {
    return Navigator.of(this).pop(result);
  }
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );
  SizedBox get px => SizedBox(
        width: toDouble(),
      );
}
