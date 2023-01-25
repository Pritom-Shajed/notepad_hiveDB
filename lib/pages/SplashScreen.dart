import 'package:flutter/material.dart';
import 'package:notepad_hive/constants/constants.dart';
import 'package:notepad_hive/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  redirectToHome() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
        return Home();
      }), (route) => false);
    });
  }

  @override
  void initState() {
    redirectToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NOTEPAD',
              style: largeText,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
