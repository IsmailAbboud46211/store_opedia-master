// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/pages/owner_signup.dart';
import 'package:shopesapp/presentation/pages/user_sign_up.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

class StartSignupPage extends StatefulWidget {
  const StartSignupPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StartSignupPage> createState() => _StartSignupPageState();
}

class _StartSignupPageState extends State<StartSignupPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: CustomPaint(
        painter: MyPainter(
            clipper: SecondClipper(), shadow: const Shadow(blurRadius: 10)),
        child: ClipPath(
          clipper: SecondClipper(),
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: CustomPaint(
                  painter: YourPainter(
                      shadow: const Shadow(blurRadius: 10),
                      clipper: thirdClipper()),
                  child: ClipPath(
                    clipper: thirdClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: AppColors.mainWhiteColor,
                      ),
                      width: size.width,
                      height: size.height * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 70),
                        child: Column(
                          children: [
                            30.ph,
                            Text(
                              LocaleKeys.sign_up_as.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.mainTextColor),
                            ),
                            30.ph,
                            SizedBox(
                              width: size.width * 0.5,
                              height: size.height * 0.06,
                              child: ElevatedButton(
                                  onPressed: () {
                                    context.push(const UserSignUp());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  child: Text(
                                    LocaleKeys.client.tr(),
                                    style: TextStyle(
                                        color: AppColors.mainWhiteColor),
                                  )),
                            ),
                            20.ph,
                            ElevatedButton(
                                onPressed: () {
                                  context.push(const OwnerSignUp());
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 60),
                                    backgroundColor: AppColors.mainWhiteColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                child: Text(
                                  LocaleKeys.store_owner.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class SecondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();

    path0.moveTo(0, 0);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width, size.height * 0.6401000);
    path0.quadraticBezierTo(size.width * 0.9453250, size.height * 0.5564000,
        size.width * 0.8811000, size.height * 0.5553857);
    path0.quadraticBezierTo(size.width * 0.8332250, size.height * 0.5523286,
        size.width * 0.7214500, size.height * 0.6154714);
    path0.quadraticBezierTo(size.width * 0.5597000, size.height * 0.7028714,
        size.width * 0.4091250, size.height * 0.6217143);
    path0.cubicTo(
        size.width * 0.3506000,
        size.height * 0.5895000,
        size.width * 0.2550750,
        size.height * 0.4892286,
        size.width * 0.1513000,
        size.height * 0.5230000);
    path0.quadraticBezierTo(size.width * 0.0439000, size.height * 0.5574571,
        size.width * 0.0026750, size.height * 0.7688429);
    path0.lineTo(0, 0);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class thirdClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.0421000, size.height * 0.1838714);
    path0.cubicTo(
        size.width * 0.0665500,
        size.height * 0.1216000,
        size.width * 0.1653750,
        size.height * 0.1093429,
        size.width * 0.2500000,
        size.height * 0.1064286);
    path0.cubicTo(
        size.width * 0.3784000,
        size.height * 0.1049286,
        size.width * 0.6261000,
        size.height * 0.1042143,
        size.width * 0.7551000,
        size.height * 0.1080143);
    path0.cubicTo(
        size.width * 0.8343500,
        size.height * 0.1090714,
        size.width * 0.9005250,
        size.height * 0.1213286,
        size.width * 0.9335250,
        size.height * 0.1702143);
    path0.cubicTo(
        size.width * 0.9736000,
        size.height * 0.2282714,
        size.width * 0.9761750,
        size.height * 0.4088286,
        size.width * 0.9415250,
        size.height * 0.4516571);
    path0.cubicTo(
        size.width * 0.8970000,
        size.height * 0.5012286,
        size.width * 0.8162500,
        size.height * 0.4977143,
        size.width * 0.7504500,
        size.height * 0.4987714);
    path0.cubicTo(
        size.width * 0.6254500,
        size.height * 0.4994571,
        size.width * 0.3727750,
        size.height * 0.5008429,
        size.width * 0.2477750,
        size.height * 0.5015286);
    path0.cubicTo(
        size.width * 0.1752750,
        size.height * 0.4993286,
        size.width * 0.0991250,
        size.height * 0.5049286,
        size.width * 0.0503750,
        size.height * 0.4544286);
    path0.cubicTo(
        size.width * 0.0136750,
        size.height * 0.4046143,
        size.width * 0.0215500,
        size.height * 0.2490000,
        size.width * 0.0421000,
        size.height * 0.1838714);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  MyPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = AppColors.mainBlueColor;
    var ClipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(ClipPath, paint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyPainter oldDelegate) => false;
}

class YourPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  YourPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = AppColors.mainBlueColor;

    var ClipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(ClipPath, paint);
  }

  @override
  bool shouldRepaint(YourPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(YourPainter oldDelegate) => false;
}
