import 'package:flutter/material.dart';
import '../app.dart';
import 'package:camera/camera.dart';

class HomePage extends StatelessWidget {
  // Impact Colours
  final Color impactGrey = const Color(0xFFC9C8CA);
  final Color impactBlack = const Color(0xFF040404);

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: impactGrey,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: impactBlack),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // This will open the drawer when the icon is pressed.
              },
            );
          },
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: impactGrey,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Account'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Logo below the AppBar
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.asset(
                  'assets/images/impact_logo.webp', // Make sure this matches the file name in your assets directory
                  height: 50, // Adjust the height accordingly
                ),
              ),
            ),
            // Welcome message
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome, Name Surname',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: impactBlack,
                ),
              ),
            ),
            // Grid for icons
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                _buildGridButton(Icons.camera_alt, 'Scan Barcode', impactGrey, context, onPressed: () async {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => BarcodeScanning( camera: firstCamera,)),
      );
    }),
                _buildGridButton(Icons.star, 'Favorites', impactGrey, context),
                _buildGridButton(Icons.search, 'Browse Products', impactGrey, context),
                _buildGridButton(Icons.history, 'Scan History', impactGrey, context),
                _buildGridButton(Icons.lock, 'Browse Brands', impactGrey, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(IconData icon, String label, Color bgColor, BuildContext context, {void Function()? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      ),
      onPressed: onPressed ,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 50.0, color: impactBlack), // Icon color set to black
          Text(
            label,
            style: TextStyle(color: impactBlack), // Text color set to black
          ),
        ],
      ),
    );
  }
}
