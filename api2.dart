import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class api2 extends StatefulWidget {
  const api2({super.key});

  @override
  State<api2> createState() => _api2State();
}

class _api2State extends State<api2> {

  Future<dynamic> splash() async{
    var res=await http.get(Uri.parse("https://api.genderize.io?name=luc"));
    var the=jsonDecode(res.body);
    return the;

  }
   void inistate(){
    super.initState();
    splash();
   }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          FutureBuilder(future: splash(), builder:(BuildContext context,snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(
          color: Colors.grey,
          backgroundColor: Colors.blue,
          
        );
      }
      else if (snapshot.hasError) {
        return Text("Error :${snapshot.error}");
      }
      else if (snapshot.hasData) {
        var the = snapshot.data;
        return Column(
          children: [
            Text("Count : ${the["count"].toString()}"),
            Text("Name : ${the["name"]}"),
            Text("Gender:${the["gender"]}"),
            Text("probability:${the["probability"]}"),
          ],
        );
      } else {
        return Text("data");
      }
    })
        ]

      ),
    );
  }
}
