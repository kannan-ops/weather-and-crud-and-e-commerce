import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;





class were extends StatefulWidget {
  const were({super.key});

  @override
  State<were> createState() => _wereState();
}

class _wereState extends State<were> {




  Future<dynamic> ghs() async{
    var res=await http.get(Uri.parse("https://api.zippopotam.us/us/33162"));
    var the=jsonDecode(res.body);
    return the;
  }
   void initstate(){
    super.initState();
    ghs();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
      Column(
        children: [
          FutureBuilder(future: ghs(), builder:(BuildContext context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if(snapshot.hasError){
              return Text("Error :${snapshot.error}");
            }
            else if(snapshot.hasData){
              var the=snapshot.data;
              var native=the["places"];
              return Column(
                children: [
                  Text("COUNTRY :           ${the["country"].toString()}"),
                  Text("COUNT ABBREVIATION :${the["country abbreviation"].toString()}"),
                  Text("POST CODE :         ${the["post code"].toString()}"),
                  ListView.builder(
                      shrinkWrap:true,
                      itemCount: native.length,
                      itemBuilder:(BuildContext context,itemindex){
                        return Column(
                          children: [
                            Text("place name          :${native[itemindex]["place name"]}"),
                            Text("longitude           :${native[itemindex]["longitude"]}"),
                            Text("latitude            :${native[itemindex]["latitude"]}"),
                            Text("state               :${native[itemindex]["state"]}"),
                            Text("state abbreviation:${native[itemindex]["state abbreviation"]}"),
                          ],
                        );
                      })
                ],
              );
            }
            else {
              return Text("ok");
            }
          })
        ],
      ),
    );
  }
}
