import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants.dart';

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
    this.animation,
  }) : super(key: key);
  final String? text, image, animation;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        const Image(
          image: AssetImage("assets/images/impactlogo.png"),
          height: 100,
          width: 235,
        ),
        Text(
          widget.text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Lottie.asset(
          widget.animation!,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}
