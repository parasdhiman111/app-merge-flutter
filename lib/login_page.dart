import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:merge2/user_data.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merge2/user_feed.dart';
import 'package:video_player/video_player.dart';
import 'video_page.dart';
import 'main.dart';






class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  bool _isLoading=false;


  Future<UserData> _signIn1(String email,String pass) async
  {
    sharedPreferences =await SharedPreferences.getInstance();
    Map data = {

      'email': email,
      'password': pass
    };


    print(email);
    print(pass);

    var headers = {
      'content-type': 'application/json'
    };


    var response= await http.post("http://api-uat.shrofile.com:8061/api/v1/authentication/login",headers: headers,body: json.encode(data));
    jsonData= json.decode(response.body);


    print("status code :");
    print(response.statusCode);

    if(response.statusCode == 200) {

      if(jsonData != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("id", jsonData['response']['id']);
        sharedPreferences.setString("token", jsonData['response']['token']);

        String uid=sharedPreferences.getString("id");
        String uToken=sharedPreferences.getString("token");




        response1 = await http.get("http://api-uat.shrofile.com:8061/api/v1/feeds/${uid}/0/5",headers:{
          'content-type': 'application/json',
          'authorization':uToken,
        });

        Navigator.of(context).pushReplacementNamed("/home");

        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (Route<dynamic> route) => false);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      }
    }
    else {
      setState(() {
        _isLoading = false;

      });
      print(response.body);
    }

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            //buttonSection(),
            SizedBox(
              height: 50,
              width: 20,
              child: FlatButton(
                textColor: Colors.black,
                color: Colors.white,
                shape: StadiumBorder(),
                onPressed: ()
                {
                  setState(() {
                    _isLoading = true;
                  });
                  _signIn1(emailController.text, passwordController.text);

                },
                child: Text("Sign In",
                style: TextStyle(
                  fontFamily: "",
                  fontSize: 15
                ),),
              ),

            ),



          ],
        ),
      ),
    );
  }





  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();




  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,

            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }





  Container headerSection() {
    return Container(

      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 80,
            width: 80,
            child:Image.network("https://lh3.googleusercontent.com/pjTzl3GfIMvs-v5I7_Tpobd5I86hdngtfMc-RsJcvtC1nZw9H2yhwE0NzeE90gb35fGB"),


          ),

          Text("Shrofile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

}


