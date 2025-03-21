import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const LoginSuccessScreen({super.key});
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
            "Login Success",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, InitScreen.routeName);
              },
              child: const Text("Go to home"),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
