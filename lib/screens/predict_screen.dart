import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:tflite/tflite.dart';

class PredictScreen extends StatefulWidget {
  final imageFile;
  const PredictScreen({this.imageFile});
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  var imageFile;
  List _output;
  detectImage() async {
    imageFile = widget.imageFile;
    var output = await Tflite.runModelOnImage(
        path: imageFile.path,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.15);
    setState(() {
      _output = output;
      print(_output);
    });
  }

  @override
  void initState() {
    super.initState();
    detectImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("prediction screeeeen"),
        ),
        body: _output != null
            ? Column(
                children: [
                  Expanded(
                    child: Image.file(imageFile),
                    flex: 3,
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _output.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Text(_output[index]["label"]),
                                  FAProgressBar(
                                    progressColor: Colors.blueAccent,
                                    displayText: "%",
                                    currentValue:
                                        (_output[index]["confidence"] * 100)
                                            .round(),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              )
            : Container());
  }
}
