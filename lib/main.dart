import 'dart:convert';

import 'package:camera/camera.dart';
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
import 'login_page.dart';
import 'camera_page.dart';
import 'splash_screen.dart';


String link;


void main() => runApp(MyApp());

SharedPreferences sharedPreferences;
var jsonResponse1,response1;
var jsonData;




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shrofile",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login':         (BuildContext context) => new LoginPage(),
        '/home':         (BuildContext context) => new MyHomePage(),
        '/video/':         (BuildContext context) => new VideoPage(),
       // '/camera':         (BuildContext context) => new CameraApp(),

        //'/' :          (BuildContext context) => new LoginPage(),
      },
      theme: ThemeData(
          accentColor: Colors.white70
      ),
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





  Future<List<UserFeed>> _getFeeds() async
  {

    //jsonResponse1=json.decode(response1.body);
    List<UserFeed> userFeeds=[];


    for(var i in jsonResponse1['response']['feeds'])
    {
      UserFeed userFeed=new UserFeed(

        i['likeCount'],
        i['replyCount'],
        i['actorInfo']['firstName'],
        i['actorInfo']['lastName'],
        i['actorInfo']['image_url'],
        i['actorInfo']['location'],
        i['resourceInfo']['coverImage'],
        i['resourceInfo']['url'],
      );

      userFeeds.add(userFeed);
    }
    print(userFeeds.length);




    return userFeeds;

  }

  Widget _feedList() =>FutureBuilder(
    future: _getFeeds(),
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.data==null)
      {
        return Container(
          child: Text("Loading"),
        );
      }
      else
      {
        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                height: 500,
                width: 400,

                child: Column(
                  children: <Widget>[


                    Container(

                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(snapshot.data[index].profilePic),

                        ),
                        title: Text("${snapshot.data[index].firstName} ${snapshot.data[index].lastName}",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ),
                    ),

                    Card(

                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: (){
                          print("card tapped");
                        },
                        child:Container(
                          height: 400,
                          width: 300,
                          padding: new EdgeInsets.only(),
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(snapshot.data[index].coverImage,
                              ),
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            ),
                          ),



                          child: new Stack(
                            children: <Widget>[
                              new Positioned(
                                left: 0.0,
                                bottom: 0.0,
                                right: 0.0,
                                top: 0.0,
                                child: new IconButton(icon: Icon(Icons.play_circle_outline,size: 70,
                                  color: Colors.white,
                                ), onPressed: (){
                                  print("button pressed");
                                  link=snapshot.data[index].videoUrl;
                                  print(link);

                                  Navigator.of(context).pushReplacementNamed("/video/");

                                }),
                              ),
                            ],
                          ),
                        ) ,
                      ),






                    ),

                    Row(

                      children: <Widget>[
                        Text("${snapshot.data[index].likes} Likes ${snapshot.data[index].comments} Comments",style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Montserrat",
                        ),
                          textAlign:TextAlign.center,
                        ),

                      ],
                    ),


                  ],
                ),

              );

            });
      }
    },

  );





  @override
  void initState() {


    super.initState();
    checkLoginStatus();
    setState(() {
      jsonResponse1=json.decode(response1.body);
    });

  }




  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.redAccent,
        title: Text("Shrofile", style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
          fontFamily: "Montserrat",
        )),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();

              Navigator.of(context).pushReplacementNamed("/login");
              //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);

            },
            child: Text("Log Out", style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",)),
          ),
        ],


      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(

        backgroundColor:Colors.redAccent,
        child:const  Icon(Icons.camera_alt,
          size: 40,
        ), onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyCameraPage()));
      },

      ),
      bottomNavigationBar: BottomAppBar(
        child: Material(

          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),

            height: 60,
            child: Row(
             mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: Icon(Icons.home,
                  color: Colors.redAccent,
                ),
                    iconSize:30,
                    onPressed: null
                ),
                IconButton(icon: Icon(Icons.work,
                  color: Colors.redAccent,
                ),
                    iconSize:30,
                    onPressed: null
                ),
                //IconButton(icon: Icon(Icons.camera_alt), onPressed: null),
                IconButton(icon: Icon(Icons.search,
                  color: Colors.redAccent,
                ),
                    iconSize:30,
                    onPressed: null
                ),
                IconButton(icon: Icon(Icons.person,
                  color: Colors.redAccent,
                ),
                    iconSize:30,
                    onPressed: null
                ),


              ],
            ),
          ),
        )
      ),

      body: Container(

        child: _feedList(),


      ),




      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(

              child: Image.network(jsonData['response']['image_url'],
                fit: BoxFit.fitHeight,),

            ),
            ListTile(
              title: Text("Hello! ${jsonData['response']['firstName']}\t ${jsonData['response']['lastName']}",
                style: _textStyle(),),
            ),
            ListTile(
              title: Text("Email : ${jsonData['response']['email']}",
                style: _textStyle(),),
            ),
            ListTile(
              title: Text("Followings : ${jsonResponse1['response']['following']}",
                style: _textStyle(),
              ),

            ),
            ListTile(
              title: Text("Followers : ${jsonResponse1['response']['followers']}",
              style: _textStyle(),),

            ),

          ],
        ),


      ),
    );
  }
TextStyle _textStyle()=>TextStyle(
  fontFamily: "Montserrat",
);


}



