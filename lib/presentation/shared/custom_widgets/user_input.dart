// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserInput extends StatefulWidget {
  UserInput(
      {Key? key,
      required this.text,
      this.controller,
      this.validator,
      this.obscureText = false,
      this.suffixIcon,
      this.prefixIcon,
      this.enabled = true,
      this.onChanged})
      : super(key: key);
  bool? obscureText;
  final Widget? suffixIcon;
  final bool? enabled;
  final Icon? prefixIcon;
  final String text;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Sizer(
      builder: (context, orientation, deviceType) => Padding(
        padding: EdgeInsets.only(top: height * 0.03),
        child: TextFormField(
          onChanged: widget.onChanged,
          enabled: widget.enabled!,
          obscureText: widget.obscureText!,
          validator: widget.validator,
          textInputAction: TextInputAction.next,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: widget.obscureText!
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText!;
                      });
                    },
                    icon: Icon(widget.obscureText!
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  )
                : widget.suffixIcon,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            hintText: widget.text,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(182, 183, 183, 1),
            ),
            filled: true,
            prefixIcon: widget.prefixIcon,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
