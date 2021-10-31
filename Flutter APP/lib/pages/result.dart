import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final congestion;
  final meandistance;
  final meanspeed;
  final meantime;

  Result({
    required this.congestion,
    required this.meandistance,
    required this.meanspeed,
    required this.meantime,
  });

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    _navigatetohome()//fn for splashscreen
    async{
      Navigator.pushReplacementNamed(context, "/a");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF62EED3),
        elevation: 20,
        leading: IconButton(onPressed: () {
          _navigatetohome();
        }, icon: Icon(Icons.arrow_back_ios_new_rounded),),
        title: Text('Results'),
      ),
      body:

      Container( //results background
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/map2.png'),
              fit: BoxFit.cover,
            )
        ),
        child:
        Center(
            child:
            Center(
              child: Container( //results card
                margin: EdgeInsets.only(
                  right: 15, left: 15,
                ),
                height: 450,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                ),
                child: FlipCard(
                  direction: FlipDirection.VERTICAL,
                  front: Card(
                      elevation: 50,
                      shadowColor: Colors.grey,
                      borderOnForeground: false,
                      color: Color(0xFF62EED3),
                      child: Center(
                          child: Text("Tap To See Results", style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                          )
                      )
                  ),
                  back: Card(
                    color: Color(0xFF62EED3),
                    elevation: 50,
                    shadowColor: Colors.grey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,padding: EdgeInsets.all(30),
                            child: Text(
                              'Congestion Level: ${widget.congestion}', style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                            )
                        ),
                        Container(
                            alignment: Alignment.centerLeft,padding: EdgeInsets.all(30),
                            child: Text(
                              'Distance: ${widget.meandistance}', style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                            )
                        ),
                        Container(
                            alignment: Alignment.centerLeft,padding: EdgeInsets.all(30),
                            child: Text(
                              'Time: ${widget.meantime}', style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                            )
                        ),
                        Container(
                            alignment: Alignment.centerLeft,padding: EdgeInsets.all(30),
                            child: Text(
                              'Speed: ${widget.meanspeed}', style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                            )
                        ),
                      ],
                    ),

                  ),

                ),
              ),
            )
        ),
      ),
    );
  }
}