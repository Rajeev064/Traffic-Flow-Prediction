import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trafficprediction2/pages/result.dart';

class Home extends StatefulWidget {
  const Home({Key? key, }) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DateTime date = DateTime.now();
  late TimeOfDay time;
  late TimeOfDay piicked;
  late String dateString = "", timeString = "";

  late String stringresponse = "", congestion = "", meanDistance = "",
      meanSpeed = "", meanTime = "", label = "", hour = "", day = "", finalUrl = "";
  late String urlTime = "",  urlDate = "";
  late String urlStreet = "";

  Map mapResponse = <String, String>{};

  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  static const roads_list =
  [
    "Adenwala Rd",
    "Adenwala Rd and Nathalal Parekh Marg",
    "Antop Hill Rd and Shaikh Misree Marg",
    "Balaram Babu Khedekar Marg",
    "Bharni Naka Rd/Sir Pochkhan Wala Rd/Vidyalankar College Rd",
    "Comrade Harbanslal Marg/Flank Rd",
    "Comrade Harbanslal Marg/Flank Rd and Dr Baba Saheb Ambedkar Rd",
    "Dadar TT Flyover/Eastern Express Hwy",
    "David S Barretto Rd",
    "David S Barretto Rd and Barkat Ali Dargah Rd",
    "Dr Baba Saheb Ambedkar Rd",
    "Eastern Express Hwy and Dr Baba Saheb Ambedkar Rd",
    "GD Ambekar Marg/Katrak Rd",
    "GD Ambekar Marg/Katrak Rd and Firdausi Rd",
    "Govindji Keni Rd",
    "Govindji Keni Rd and GD Ambekar Marg/Katrak Rd",
    "Govindji Keni Rd, Mahatma Jyotiba Phule Rd/Naigaon Rd and BJ Deorukhkar Marg/BJ Devrukhkar Rd",
    "H R Mahajani Rd",
    "Jerbai Wadia Rd",
    "Kings Cir/Matunga Cir and Puranmal Singhani Rd",
    "Lady Jamshedji Rd/LJ Rd and N C. Kelkar Rd",
    "Lady Jehangir Rd",
    "Mahatma Jyotiba Phule Rd/Naigaon Rd and MMGS Marg/Naigaon Cross Rd",
    "Mancherji Joshi Rd",
    "N C. Kelkar Rd and Lady Jamshedji Rd",
    "Nathalal Parekh Marg and Rafi Ahmed Kidwai Rd",
    "Puranmal Singhani Rd and Nathalal Parekh Marg",
    "Rafi Ahmed Kidwai Rd",
    "Rd Number 16 and Barkat Ali Dargah Rd",
    "SM Uphill Rd",
    "Shaikh Misree Marg",
    "Shaikh Misree Marg and JK Bhasin Marg",
    "Shaikh Misree Marg and SM Uphill Rd",
    "Taikalwadi Marg and JK Sawant Marg",
    "Tilak Rd",
    "Tilak Rd and Firdausi Rd",
    "Tilak Rd/Tilak Bridge/Tilak Flyover",
  ];


  Future<void> fetchdata() async{
    String base = "https://traffic-flow-predictor.herokuapp.com/predict?";
    String street = "street=$urlStreet&";
    String time = "time="+"$urlTime&";
    String date = "date=$urlDate";

    finalUrl = "$base" + "$street" + "$time" + "$date";
    print(finalUrl);


    var url = Uri.parse(finalUrl);
    print(url);
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      if(!mounted){
        print('not mounted');
      }
      setState(() {
        mapResponse = json.decode(response.body);
        print(mapResponse);
        congestion = mapResponse["congestion"].toString();
        meanDistance = mapResponse["mean_distance"].toString();
        meanSpeed = mapResponse["mean_speed"].toString();
        meanTime = mapResponse["mean_time"].toString();
        print(congestion);
      });
    }
    else {
      print('Failed');
    }
  }

   Future<Null> selectTimePicker(BuildContext context)async{
     //picked named intentionally
     final DateTime piicked = (await showDatePicker(
         context: context,
         initialDate: date,
         firstDate: DateTime(2000),
         lastDate: DateTime(2023)))!;

     if(true){
          setState(() {
            date = piicked;
          });
     print(date);
     }
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    time = TimeOfDay.now();

  }

  Future<Null> selectTime (BuildContext context)async{
    piicked = (await showTimePicker(
        context: context,
        initialTime: time
    ))!;

    if (true){
      setState(() {
        time = piicked;
      });
      print(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        body:
        Container(//background of the app
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/map2.png'),
                fit: BoxFit.cover,
              )
          ),
          child:
          SingleChildScrollView(//to avoid widget overflow
            child:
            Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      height: 50,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Container(
                                height: 45,
                                width: 380,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 5 ,
                                          blurRadius: 15.0,
                                          offset: Offset(0 , 5)
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: TypeAheadField(
                                  suggestionsCallback: (pattern)=> roads_list.where((item) =>
                                      item.toLowerCase().contains(pattern.toLowerCase())
                                  ),
                                  itemBuilder: (_, String item)=> ListTile(title: Text(item),),
                                  onSuggestionSelected: (String val){
                                    Icon(Icons.cancel_outlined, size: 25);
                                    this.textEditingController.text = val;
                                    setState(() {
                                      urlStreet = val;
                                    });

                                    print(val);
                                  },
                                  getImmediateSuggestions: true,
                                  hideSuggestionsOnKeyboardHide: true,
                                  hideOnEmpty: false,
                                  noItemsFoundBuilder: (context)=> Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(child: Text('No Routes Found',
                                      style: TextStyle(
                                        fontSize: 30
                                    ),
                                    )
                                    ),
                                  ),
                                  textFieldConfiguration: TextFieldConfiguration(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search_rounded, size: 25),
                                      hintText: 'Search for Routes...',
                                      hintStyle: TextStyle(fontSize: 20),
                                      border: InputBorder.none,
                                    ),
                                    controller: this.textEditingController,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Row(//date time box row
                      children: [
                        Center(
                          child: Container(//time selection block
                            height: 190,
                            width: 170,
                            margin: EdgeInsets.only(right:15,left: 23, top: 420),
                            decoration: BoxDecoration(
                                color: Colors.white,//change
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 5 ,
                                      blurRadius: 15.0,
                                      offset: Offset(0 , 5)//change
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            child: Column(
                              children: [
                                Container(//line 1
                                    padding: EdgeInsets.only(top: 20),
                                    child:
                                    Text(
                                      'Select Time',
                                      style: TextStyle(
                                          fontSize: 25,fontWeight: FontWeight.bold
                                      ),
                                    )
                                ),
                                Container(//icon
                                  padding: EdgeInsets.only(right: 25,top: 7),
                                  child: IconButton(onPressed: () {
                                    selectTime(context);
                                    urlTime = '${time.hour}:${time.minute}';
                                    print(urlTime);
                                  },
                                    icon: Icon(Icons.alarm , color: Colors.black,size: 60,),
                                  ),
                                ),//icon
                                Container(//line 2
                                    padding: EdgeInsets.only(top: 35),
                                    child:
                                    Text(
                                      'Time: ${time.hour}:${time.minute}',
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                    )
                                ),
                              ],//children end
                            ),//searchbar1content ends
                          ),
                        ),
                        Center(//date selection block
                          child: Container(
                            height: 190,
                            width: 170,
                            margin: EdgeInsets.only(right:15,left: 15, top: 420),
                            decoration: BoxDecoration(
                                color: Colors.white,//change
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 5 ,
                                      blurRadius: 15.0,
                                      offset: Offset(0 , 5)//change
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: Column(
                              children: [
                                Container(//line one
                                    padding: EdgeInsets.only(top: 20),
                                    child:
                                    Text(
                                      'Select Date',
                                      style: TextStyle(
                                          fontSize: 25,fontWeight: FontWeight.bold
                                      ),
                                    )
                                ),

                                Container(//icon
                                  padding: EdgeInsets.only(right: 15,top:10),
                                  child: IconButton(onPressed: () {
                                    selectTimePicker(context);
                                    print(date);
                                    String ud = DateFormat('dd-MM-yyyy').format(date);
                                    urlDate = ud.replaceAll('-', ' ');
                                    // Use this dateString parameter in the backend
                                    print(urlDate);
                                  },
                                    icon: Icon(Icons.calendar_today_rounded ,
                                      color: Colors.black,
                                      size: 50,),
                                  ),
                                ),//icon
                                Container(//line 2
                                    padding: EdgeInsets.only(left: 50, top:35),
                                    child:
                                    Row(
                                      children: [
                                        Text(
                                          date.day.toString(),
                                          style: TextStyle(
                                              fontSize: 18
                                          ),
                                        ),
                                        Text('/'),
                                        Text(
                                          date.month.toString(),
                                          style: TextStyle(
                                              fontSize: 18
                                          ),
                                        ),
                                        Text('/'),
                                        Text(
                                          date.year.toString(),
                                          style: TextStyle(
                                              fontSize: 18
                                          ),
                                        ),],
                                    )
                                ),
                              ],//children end
                            ),//searchbar1content ends
                          ),
                        ),
                      ],
                    ),
                  ],//children
                ),
                Center(
                  child: Container(//submit button
                      decoration: BoxDecoration(
                          color: Colors.white,//change
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 5 ,
                                blurRadius: 15.0,
                                offset: Offset(0 , 5)//change
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(35))
                      ),
                      height: 60,
                      width: 120,
                      margin: EdgeInsets.only(right:15,left: 15, top: 75),
                      child: ElevatedButton(
                          onPressed: () async{
                            await fetchdata();
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            new Result(congestion: congestion, meandistance: meanDistance,
                                meanspeed: meanSpeed, meantime: meanTime))
                            );
                            print('$congestion, $meanDistance, $meanSpeed, $meanTime');
                            // _navigatetohome();
                          },
                          child: Text('Submit', style: TextStyle(
                              fontSize: 25
                          ),)
                      )
                  ),
                ),
              ],

            ),
          ),
        )
      );

  }
}
