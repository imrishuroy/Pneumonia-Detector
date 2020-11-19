import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

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
  List _result;
  String _name = '';
  String _confidence = '';

  Future getImage() async {
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        isLoaded = true;
      } else {
        //print('Something went wrong');
      }
    });
    detectImage(File(pickedImage.path));
  }

  loadModal() async {
    var res = await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
      numThreads: 1, // defaults to 1
      isAsset:
          true, // defaults to true, set to false to load resources outside assets
      useGpuDelegate: false,
    );
    //print('Res : ${res.toString()}');
  }

  @override
  void initState() {
    super.initState();
    loadModal();
  }

  detectImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5, // defaults to 117.0
      imageStd: 127.5, // defaults to 1.0
      numResults: 2, // defaults to 5
      threshold: 0.5, // defaults to 0.1
      asynch: true,
    );
    print('Rec : ${recognitions.toString()}');
    setState(() {
      _result = recognitions;
      String str = _result[0]['label'];
      _name = str.substring(2);
      _confidence = _result != null
          ? (_result[0]['confidence'] * 100).toString().substring(0, 2) + '%'
          : '';
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
          SizedBox(height: 50.0),
          Text('Condition : $_name'),
          SizedBox(height: 20.0),
          Text('Confidence : $_confidence'),
          // FlatButton(
          //   onPressed: () {
          //     // detectImage();
          //   },
          //   child: Text(
          //     'Detect',
          //     style: TextStyle(
          //       fontSize: 20,
          //       color: Colors.teal,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
