import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:opencv/opencv.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Image Picker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final ImagePicker _imagePicker = ImagePickerChannel();

  File _imageFile;
  dynamic _imageOpenCVFile;
  OpenCV opencv = new OpenCV();

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      var imageOpenCV = await imageFile.readAsBytes();
      dynamic findContours = await opencv.findContours(imageOpenCV);

      setState(() {
        _imageFile = imageFile;
        _imageOpenCVFile = findContours;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildOriginalImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else {
      return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
    }
  }

  List<Widget> _buildOpenCVImages() {
    if (_imageOpenCVFile == null)
      return <Widget>[
        // _buildButtons(),
        _buildOriginalImage(),
        Image.asset('assets/temp.png'),
      ];

    List<Widget> list = new List<Widget>();

    // list.add(_buildButtons());
    list.add(_buildOriginalImage());

    for (var i = 0; i < _imageOpenCVFile.length; i++) {
      list.add(Image.memory(_imageOpenCVFile[i]));

      if (i > 200) break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Column(children: <Widget>[
      _buildButtons(),
      Expanded(
          child: new ListView(shrinkWrap: true, children: _buildOpenCVImages()))
    ]
            // <Widget>[

            // _buildImage(),
            // _buildOpenCVImages(),
            // _buildButtons(),
            // ],
            ));
  }

  Widget _buildButtons() {
    return ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(
                key: Key('retake'),
                text: 'Photos',
                onPressed: () => captureImage(ImageSource.gallery),
              ),
              _buildActionButton(
                key: Key('upload'),
                text: 'Camera',
                onPressed: () => captureImage(ImageSource.camera),
              ),
            ]));
  }

  Widget _buildActionButton({Key key, String text, Function onPressed}) {
    return Expanded(
      child: FlatButton(
          key: key,
          child: Text(text, style: TextStyle(fontSize: 20.0)),
          shape: RoundedRectangleBorder(),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: onPressed),
    );
  }
}

class OpenCV {
  Future<dynamic> findContours(Uint8List bytes) async {
    try {
      var result = await ImgProc.findContours(
          await bytes, ImgProc.cvRetrTree, ImgProc.cvChainApproxsimple);

      return result;
    } catch (e) {
      print(e);
    }

    return null;
  }
}
