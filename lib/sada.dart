import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tensor/principal.dart';
void main() => runApp(MaterialApp(
  title: 'LINSU IA',
  theme: ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
    primarySwatch: Colors.blue,
  ),
  home: Pagina(),
));


class Pagina extends StatefulWidget {
  @override
  _PaginaState createState() => _PaginaState();
}

class _PaginaState extends State<Pagina> {
  final FirebaseAuth firebaseauth=FirebaseAuth.instance;
  final GoogleSignIn googleSignIn=new GoogleSignIn();

  Future<FirebaseUser> signIn()async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final FirebaseUser user = await firebaseauth.signInWithCredential(credential);

    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) => MyHomePag(user: user,googleSignIn: googleSignIn,)));
    return user;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/logo.png"),
            Padding(padding: EdgeInsets.only(bottom: 30.0),),
            InkWell(
              onTap: (){

                signIn();

              },
              child: Text('Iniciar Sesion'),
            )
          ],
        ),
      ),

    );
  }
}
