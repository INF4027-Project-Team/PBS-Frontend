import 'package:flutter/material.dart';
class NetworkDisplayCard extends StatelessWidget {
  final String logoPath;
  final String siteName;
  final int offersCount;
  final VoidCallback onTap;

  const NetworkDisplayCard({
    super.key,
    required this.logoPath,
    required this.siteName,
    required this.offersCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Set card background to white
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(logoPath, width: 130), // Increased logo size
              SizedBox(width: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.center, // Center text horizontally and vertically
                  child: Text(
                    '$siteName\nOffers available: $offersCount',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    
                    //textAlign: TextAlign.center, // Ensure text is centered if it wraps
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}