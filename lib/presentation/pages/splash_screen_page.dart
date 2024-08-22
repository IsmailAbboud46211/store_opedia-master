import 'package:flutter/material.dart';
import 'package:shopesapp/presentation/pages/control_page.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000))
        .then((value) => context.pushRepalceme(const ControlPage()));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainWhiteColor,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(fit: StackFit.expand, children: [
            Center(
              child: Image.asset(
                'assets/storopedia_logo.jpg',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.width * 0.2),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
