import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tensor/Reconocimiento.dart';
import 'package:tensor/sada.dart';
import 'package:tensor/Favo.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
class MyHomePag extends StatefulWidget {
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  MyHomePag({this.user,this.googleSignIn});

  @override
  _MyHomePagState createState() => _MyHomePagState();
}

class _MyHomePagState extends State<MyHomePag> {
  var options=[
    //Recono(),
    Favori(),
  ];
  int currentTab=0;
  File imagen;
  List<Face> _faces;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
  Future detectar() async{


    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
   final image= FirebaseVisionImage.fromFile(imageFile);
    final face=FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
          mode: FaceDetectorMode.accurate
      ),
    );
    final faces= await face.processImage(image);
    if(mounted){
      setState(() {
        imagen=imageFile;
        _faces=faces;
      });
    }

  }
  void confirm(){

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          title: new Text("¿Desea cerrar sesion?"),
           content: Text(widget.user.displayName),
          actions: <Widget>[
            new FlatButton(onPressed: (){
              widget.googleSignIn.signOut();
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) => Pagina()));

            }, child: new Text("Si"), ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("LINSU IA"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
            confirm();
          },)
        ],
      ),
      body: imagen!=null ? Recono(imagen, _faces) :Container(),
     drawer: Drawer(
       child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(accountName: Text(widget.user.displayName), accountEmail: Text(widget.user.email),currentAccountPicture: Container(

            width: 54.0,
            height: 54.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(widget.user.photoUrl,),fit: BoxFit.cover),
            ),
          ),),
          ListTile(leading: Icon(Icons.camera_alt),title: Text("Reconocimiento de Imagenes"),onTap: (){

          },),
          Divider(),
          ListTile(leading: Icon(Icons.text_fields),title: Text("Reconocimiento de Texto"),onTap: (){

          },),
          Divider(),
          ListTile(leading: Icon(Icons.place),title: Text("Lugares"),onTap: (){

          },),
        ],
       )
     ),
      floatingActionButton: FloatingActionButton(onPressed:detectar,child: Icon(Icons.add),),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
          });
        },

        items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Recientes'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text("Favoritos"),
        ),
       
      ],),
      
    );
  }
}
