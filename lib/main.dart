import 'package:flutter/material.dart';
import 'package:qr_scan/scanner.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}


//* HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: IconButton(
          iconSize: 150,
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Scanner(),
              ),
            );
          },
          icon:  const Icon(
            Icons.qr_code_scanner,
            color: Colors.black87,
            )
          ),
      ),
    );
  }
}