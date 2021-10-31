import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  _SplashScreen1State createState() => _SplashScreen1State();

}

class _SplashScreen1State extends State<SplashScreen1>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigatetohome();

  }
  _navigatetohome()
  async{
    await Future.delayed(Duration(seconds: 6),(){});
    Navigator.pushReplacementNamed(context, "/a");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Material(
          child:
          Lottie.asset("assets/animation/traffic.json"),
        ),
      ),
    );
  }
}


