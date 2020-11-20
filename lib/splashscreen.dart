import 'package:flutter/material.dart';
import 'package:pneumonia_detector/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomePage(),
      title: Text(
        'Pneumonia Detector',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.teal,
          fontWeight: FontWeight.w500,
        ),
      ),
      image: Image.asset('images/splash.png'),
      backgroundColor: Colors.black,
      photoSize: 110.0,
      loaderColor: Colors.teal,
    );
  }
}
