import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class api4 extends StatefulWidget {
  const api4({super.key});

  @override
  State<api4> createState() => _api4State();
}

class _api4State extends State<api4> {
  Future<dynamic> call() async{
    var res=await http.get(Uri.parse("https://api.ipify.org?format=json"));
    var answer=jsonDecode(res.body);
    return answer;
  }
  
  void inistate(){
    super.initState();
    call();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          FutureBuilder(future: call(), builder:(BuildContext context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else if(snapshot.hasError){
            return Text("Error :${snapshot.error}");
          }
          else if(snapshot.hasData){
            var answer=snapshot.data;
            return Column(
              children: [
                Text("IP  :${answer["ip"]}")
                
              ],
            );
          }else {
            return Text("ok");
          }
          })
        ],
      ),
    );
  }
}
