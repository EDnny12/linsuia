import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
class Recono extends StatelessWidget {

  Recono(this.ima, this.faces);

  final File ima;
  List<Face> faces;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Image.file(ima, fit: BoxFit.cover,),
          ),
        ),
        Flexible(
          flex: 1,
          child: ListView(
            children: faces.map<Widget>((f) => FaceCoordenadas(f)).toList(),
          ),
        )

      ],
    );
  }
}
class FaceCoordenadas extends StatelessWidget {
   FaceCoordenadas(this.face);
  final Face face;
  @override
  Widget build(BuildContext context) {
    final pos=face.boundingBox;
    return ListTile(title: Text('(${pos.top},${pos.left},${pos.bottom},${pos.right})'),);
  }
}

