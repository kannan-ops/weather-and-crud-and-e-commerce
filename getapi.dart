import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class getApi extends StatefulWidget {
  const getApi({super.key});

  @override
  State<getApi> createState() => _getApiState();
}

class _getApiState extends State<getApi> {

  Future<dynamic> fetchdata () async {
    var res = await http.get(Uri.parse("https://api.agify.io?name=meelad"));
    var data = jsonDecode(res.body);
    return data;
  }


  void initSate(){
    super.initState();
    fetchdata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(future: fetchdata(), builder: (BuildContext context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            } else if(snapshot.hasError){
              return Text("Error :  ${snapshot.error}");
            } else if(snapshot.hasData){
              var data = snapshot.data;
              return Column(
                children: [
                  Text("Count : ${data["count"].toString()}"),
                  Text("Name : ${data["name"]}"),
                  Text("Age : ${data["age"].toString()}"),
                ],
              );
            } else{
              return Text("data");
            }
          })
        ],
      ),
    );
  }
}
