import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File image;
  bool isLoaded = false;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        isLoaded = true;
      } else {
        print('Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.add_a_photo,
        ),
        onPressed: () {
          getImage();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Pneomonia Detector'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              child: isLoaded ? Image.file(image) : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
