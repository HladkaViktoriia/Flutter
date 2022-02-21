import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
          ),
        ),
        body: Column(
          children: <Widget>[
            Header(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Text(
                'Смотрите прямой эфир канала Ukrlive',
                textAlign: TextAlign.center,
                style: new TextStyle(height: 1.5, fontSize: 16.0, color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Вы можете смотреть нас также на сайте ',
                  style: TextStyle(height: 1.5, fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: '112ua.tv',
                      style: TextStyle(fontWeight: FontWeight.w600, decoration: TextDecoration.underline,),
                      recognizer: TapGestureRecognizer()
                        ..onTap = ()  {
                          launch('https://112ua.tv/');
                        }
                    )
                  ]
                ),
              ),
            ),
            Video(),
          ],
        )
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      height: 90,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage("assets/images/bg.jpg"),
          )
      ),
      child: HeaderImg(),
    );
  }
}

class HeaderImg extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Align (
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          launch('https://pnktv.news/');
        },
        child: Image.asset("assets/images/logo.png", width: 135),
      ),
    );
  }
}

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController controller;
  late Future<void> futureController;

  bool isClicked = false;

  @override
  void initState() {
    //url to load network
    controller = VideoPlayerController.network("https://app.live.112.events/hls/112hd_hi/index.m3u8");
    futureController = controller.initialize();

    controller.setLooping(true);  // this will keep video looping active, means video will keep on playing
    controller.setVolume(25.0);  // default  volume to initially play the video
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: FutureBuilder(
            future: futureController,
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller)
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        ),
        //button to play/pause the video
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: ButtonTheme(
              minWidth: double.infinity,
              height: double.infinity,
              child: AnimatedOpacity(
                curve: Curves.linear,
                opacity: isClicked ? 0.0 : 1.0,
                duration: Duration(milliseconds: 0),
                child: MaterialButton(
                  color: Colors.transparent,
                  child: Image.asset("assets/icons/icon-btn.webp", width: isClicked ? double.infinity : 70),
                  onPressed: (){
                    setState(() {
                      if(controller.value.isPlaying) {
                        isClicked = false;
                        controller.pause();
                      } else {
                        isClicked = true;
                        controller.play();
                      }
                    });
                  },
                ),
              ),
            )
          )
        )
      ],
    );
  }
}