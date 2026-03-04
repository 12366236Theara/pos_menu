import 'package:flutter/material.dart';

class LocationBlockPage extends StatelessWidget {
  const LocationBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.location_off, size: 80, color: Colors.red),
            SizedBox(height: 16),
            Text('Please scan this QR inside the restaurant', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
