//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trafficprediction2/pages/home.dart';
import 'splashscreen/splashscreen1.dart';
import 'splashscreen/splashscreen2.dart';
import 'package:trafficprediction2/pages/result.dart';


void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
      .light//status bar theme
    // ()
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home:SplashScreen1(),

      routes:   {//page changes
        '/a':(context)=>Home(),
        // '/b':(context)=>SplashScreen2(),
        // '/c':(context)=>Result(),
      },

    );
  }

}
