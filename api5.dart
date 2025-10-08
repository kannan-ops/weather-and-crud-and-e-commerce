import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class api5 extends StatefulWidget {
  const api5({super.key});

  @override
  State<api5> createState() => _api5State();
}

class _api5State extends State<api5> {
  Future<dynamic> blue() async{
    var res=await http.get(Uri.parse("https://ipinfo.io/161.185.160.93/geo"));
    var day=jsonDecode(res.body);
    return day;
  }
  
  void inistate(){
    super.initState();
    blue();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          FutureBuilder(future: blue(), builder:(BuildContext context,snapshot){
            if (snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if(snapshot.hasError){
              return Text("Error :${snapshot.error}");
            }
            else if(snapshot.hasData){
              var day=snapshot.data;
              return Column(
                children: [
                  Text("IP  :${day["ip"]}"),
                  Text("CITY :${day["city"]}"),
                  Text("REGION :${day["region"]}"),
                  Text(" COUNTRY :${day["country"]}"),
                  Text("LOC  :${day["loc"]}"),
                  Text("ORG  :${day["org"]}"),
                  Text("POSTAL  :${day["postal"]}"),
                  Text("TIMEZONE  :${day["timezone"]}"),
                  Text("README :${day["readme"]}"),
                ],
              );
            }else{
              return Text("ok");
            }
    })
        ],
      ) ,
    );
  }
}
