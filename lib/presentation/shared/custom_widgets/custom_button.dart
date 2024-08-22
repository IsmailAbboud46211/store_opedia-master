import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;

  final void Function()? onPressed;
  final String? imageName;
  final bool? loader;
  const CustomButton({
    Key? key,
    required this.text,
    this.color,
    this.textColor,
    this.borderColor,
    this.onPressed,
    this.imageName,
    this.loader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Sizer(builder: (context, orientation, deviceType) {
      return ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
              fixedSize: Size(
                size.width,
                15.w,
              ),
              shape: const StadiumBorder(),
              backgroundColor: color ?? Theme.of(context).colorScheme.primary,
              side: borderColor != null
                  ? BorderSide(
                      width: 1,
                      color:
                          borderColor ?? Theme.of(context).colorScheme.primary,
                    )
                  : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageName != null) ...[
                10.w.px,
              ],
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 18),
              ),
            ],
          ));
    });
  }
}
