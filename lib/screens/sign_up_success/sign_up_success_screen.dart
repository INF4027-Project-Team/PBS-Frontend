import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

class SignUpSuccessScreen extends StatelessWidget {
  static String routeName = "/signup_success";

  const SignUpSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        //title: const Text("Login Success"),
      ),
      body: Column(
        children: [
          //const SizedBox(height: 16),
          Image.asset(
            "assets/images/check.png",
            height: 150, //40%
          ),
          const Spacer(),
          const SizedBox(height: 25),
          const Text(
            "You have succesfully registered",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
                    "Please Sign in on the next screen",
                    textAlign: TextAlign.center,
                  ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
              child: const Text("Continue"),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
