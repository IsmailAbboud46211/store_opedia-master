import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Padding(
        padding: EdgeInsets.symmetric(vertical: h * 0.01),
        child: const Divider());
  }
}
