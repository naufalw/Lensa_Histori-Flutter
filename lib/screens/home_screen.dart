import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lensa_histori/screens/predict_screen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
        child: Scaffold(
          drawer: Drawer(),
          appBar: AppBar(
            title: Text("Sar Plox Bang"),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "AI Recognizer",
            child: Icon(
              LineIcons.camera,
              size: 34,
            ),
            isExtended: true,
            onPressed: () {
              showModalActionSheet(
                  context: context,
                  title: "Select Source",
                  message: "Select source for AI recognizer",
                  actions: [
                    SheetAction(
                        label: "Camera", icon: LineIcons.camera, key: "camera"),
                    SheetAction(
                        label: "Gallery", icon: LineIcons.image, key: "gallery")
                  ]).then(
                (value) {
                  if (value == "camera") {
                    ImagePicker().getImage(source: ImageSource.camera).then(
                      (value) {
                        if (value != null) {
                          Get.to(() => PredictScreen(
                                imageFile: File(value.path),
                              ));
                        }
                      },
                    );
                  } else if (value == "gallery") {
                    ImagePicker().getImage(source: ImageSource.gallery).then(
                      (value) {
                        if (value != null) {
                          Get.to(() => PredictScreen(
                                imageFile: File(value.path),
                              ));
                        }
                      },
                    );
                  }
                },
              );
            },
          ),
        ));
  }
}
