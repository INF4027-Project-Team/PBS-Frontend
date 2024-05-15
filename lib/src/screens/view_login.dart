import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  //Impact Colours
  final Color impactGrey = Color(0xFFC9C8CA);
  final Color impactRed = Color(0xFFF4333C);
  final Color impactBlack = Color(0xFF040404);
  final Color impactPurple = Color(0xFF6A1B9A);

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: impactGrey,
        elevation: 0, // Removes the shadow from the AppBar.
        leading: IconButton(
          icon: Icon(Icons.menu, color: impactBlack),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Logo and Welcome Text
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/images/impact_logo.png',
                      height: 50, // Logo height
                    ),
                  ),
                  const SizedBox(height: 8), // Spacing between logo and text
                  Text(
                    'Welcome to Impact.com\'s\nProduct Barcode Scanner',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: impactBlack,
                    ),
                  ),
                  const SizedBox(height: 16), // Spacing before the text fields
                ],
              ),
            ),
            // Email TextFormField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8), // Spacing between text fields
            // Password TextFormField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextFormField(
                obscureText: true, // Hides password text
                decoration: const InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
              backgroundColor: impactPurple, // Updated to backgroundColor
      minimumSize: const Size(double.infinity, 50), // Set the button's size
                ),
                onPressed: () {
                  // Implement login logic
                },
                child: const Text('Login'),
              ),
            ),
            // Forgot password and Privacy Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: impactBlack, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Implement functionality for forgot password
                      },
                    ),
                    const SizedBox(height: 4), // Spacing between text
                    InkWell(
                      child: Text(
                        'Privacy',
                        style: TextStyle(color: impactBlack, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Implement functionality for privacy
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
