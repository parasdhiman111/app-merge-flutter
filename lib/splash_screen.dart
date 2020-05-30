import 'dart:async';

import 'package:flutter/material.dart';
import 'main.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget
{
  @override
  _SplashScreenState createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context)=>LoginPage(),

      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body:
        Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [Colors.redAccent, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter),
    ),

        child: Center(
            child:
            Text("Shrofile",
              style:
              TextStyle(
                fontSize: 70.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),)
        ),
        ),


    );
  }
}