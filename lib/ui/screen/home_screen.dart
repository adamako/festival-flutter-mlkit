
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                Container(
                  height: 200,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Text OCR'),
                      onPressed: () => {print('Hello')},
                    ),
                    ElevatedButton(
                      child: Text('Barcode Scanner'),
                      onPressed: () => {print('Hello')},
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
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resultat: ',
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
