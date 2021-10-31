import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {

  @override
  void initState() {
    super.initState();
    _navigatetohome();

  }
  _navigatetohome()
  async{
    await Future.delayed(Duration(seconds: 4),(){});
    Navigator.pushReplacementNamed(context, "/c");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      body:
        Center(
          child: Container(
            child:
            Lottie.asset("assets/animation/mapicon.json"),
          ),
        ),
      );
  }
}
