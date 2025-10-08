import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class api6 extends StatefulWidget {
  const api6({super.key});

  @override
  State<api6> createState() => _api6State();
}

class _api6State extends State<api6> {
  
  Future<dynamic> sorry() async{
    var res=await http.get(Uri.parse("https://official-joke-api.appspot.com/random_joke"));
    var the= jsonDecode(res.body);
    return the;
  }
  
  void inistate(){
    super.initState();
    sorry();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          FutureBuilder(future: sorry(), builder:(BuildContext context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if(snapshot.hasError){
              return Text("Error :${snapshot.error}");
            }
            else if(snapshot.hasData){
              var the=snapshot.data;
              return Column(
                children: [
                  Text("TYPE  :${the["type"]}"),
                  Text("SETUP  :${the["setup"]}"),
                  Text("PUNCHLINE :${the["punchline"]}"),
                  Text("ID  :${the["id"]}"),
                ],
              );
            }else {
              return Text("ok");
            }
    })
        ]
      ),
    );
  }
}
