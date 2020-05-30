import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';
import 'user_feed.dart';


int index;


class VideoPage extends StatefulWidget {



  VideoPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _VideoPageState createState() => _VideoPageState();
}


class _VideoPageState extends State<VideoPage>
{
  VideoPlayerController _controller;
  Future<void> _intializeVideoPlayerFuture;

  List<String> usersVideos=[];

  Future<List<String>> _getVideos() async
  {


    for(var i in jsonResponse1['response']['feeds'])
    {
      String userVideo= i['resourceInfo']['url'];
      usersVideos.add(userVideo);
    }
    print("user videos : length");
    print(usersVideos.length);

    print("user array : ");
    usersVideos.forEach((fruit) => print(fruit));
    return usersVideos;

  }

  Widget _abc() =>FutureBuilder(




    future: _intializeVideoPlayerFuture,
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.connectionState==ConnectionState.done)
      {
        return AspectRatio(
          aspectRatio:16/19,

          child: VideoPlayer(_controller,
          ),
        );
      }
      else
      {
        return Center(child: CircularProgressIndicator(backgroundColor: Colors.red,),);
      }
    },
  );




  @override
  void initState() {
    _getVideos();

    _controller=VideoPlayerController.network("${link}".replaceAll(new RegExp(r'http:'), 'https:'));


    // _controller= VideoPlayerController.network("${usersVideos[2]}".replaceAll(new RegExp(r'http:'), 'https:'));
    _intializeVideoPlayerFuture=_controller.initialize();
    _controller.setLooping(true);


    super.initState();
    setState(() {
      _controller.play();
    });



  }


  @override
  void dispose()
  {
    _intializeVideoPlayerFuture=null;

    _controller.dispose();
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Video Page"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {

              Navigator.of(context).pushReplacementNamed("/home");


            },
            child: Text("Back", style: TextStyle(color: Colors.white)),
          ),

        ],
      ),
      body: Container(
        height: 700,


        child: Card(


            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: ()
              {
                print("tapped");
                setState(() {


                  if (_controller.value.isPlaying) {

                    _controller.pause();

                  } else {
                    // If the video is paused, play it.
                    _controller.play();
                  }

                });
              },
              child: _abc(),
            )

        ),
      ),


    );
  }

}