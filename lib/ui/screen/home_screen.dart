import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String extractedText = '';
  final textDetector = GoogleMlKit.vision.textDetector();
  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  final imageLabeler = GoogleMlKit.vision.imageLabeler();

  Future<bool> _pickImage() async {
    setState(() => this._imageFile = null);

    final imageFile = await showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Prendre une nouvelle photo'),
                  onTap: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    final imageFile = File(pickedFile!.path);
                    Navigator.pop(ctx, imageFile);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Choisir dans la gallerie'),
                  onTap: () async {
                    try {
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      final imageFile = File(pickedFile!.path);
                      print(imageFile);
                      Navigator.pop(ctx, imageFile);
                    } catch (e) {
                      print(e);
                      Navigator.pop(ctx, null);
                    }
                  },
                )
              ],
            ));

    setState(() => this._imageFile = File(imageFile.path));

    return true;
  }

  Future extractText() async {
    try {
      await _pickImage();
      if (this._imageFile == null) return;

      final RecognisedText recognisedText = await textDetector
          .processImage(InputImage.fromFile(this._imageFile!));
      setState(() {
        this.extractedText = recognisedText.text;
      });
    } catch (e) {
      print(e);
    }
  }

  Future scanBarCode() async {
    try {
      await _pickImage();
      if (this._imageFile == null) return;

      final List<Barcode> barcodes = await barcodeScanner
          .processImage(InputImage.fromFile(this._imageFile!));
      for (Barcode barcode in barcodes) {
        final BarcodeType type = barcode.type;
        final Rect boundingBox = barcode.value.boundingBox!;
        final String displayValue = barcode.value.displayValue!;
        final String rawValue = barcode.value.rawValue!;

        print('Display value: $displayValue');
        print('Raw value: $rawValue');
        print('Type: $type');

        // See API reference for complete list of supported types
        switch (type) {
          case BarcodeType.wifi:
            BarcodeValue barcodeWifi = barcode.value;
            break;
          case BarcodeType.url:
            BarcodeValue barcodeUrl = barcode.value;
            break;
          case BarcodeType.unknown:
            // TODO: Handle this case.
            break;
          case BarcodeType.contactInfo:
            // TODO: Handle this case.
            break;
          case BarcodeType.email:
            // TODO: Handle this case.
            break;
          case BarcodeType.isbn:
            // TODO: Handle this case.
            break;
          case BarcodeType.phone:
            // TODO: Handle this case.
            break;
          case BarcodeType.product:
            // TODO: Handle this case.
            break;
          case BarcodeType.sms:
            // TODO: Handle this case.
            break;
          case BarcodeType.text:
            // TODO: Handle this case.
            break;
          case BarcodeType.geographicCoordinates:
            // TODO: Handle this case.
            break;
          case BarcodeType.calendarEvent:
            // TODO: Handle this case.
            break;
          case BarcodeType.driverLicense:
            // TODO: Handle this case.
            break;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML Kits'),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          flex: 4,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                this._imageFile == null
                    ? Container(
                        height: 200,
                        color: Colors.grey,
                      )
                    : Container(
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: FileImage(this._imageFile!),
                        ),
                        height: 200,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Text OCR'),
                      onPressed: () => extractText(),
                    ),
                    ElevatedButton(
                      child: Text('Barcode Scanner'),
                      onPressed: () => scanBarCode(),
                    ),
                    ElevatedButton(
                      child: Text('Image Labelling'),
                      onPressed: () => {print('Hello')},
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resultat: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    this.extractedText,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            flex: 6)
      ]),
    );
  }
}
