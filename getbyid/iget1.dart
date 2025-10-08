import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class iget1 extends StatefulWidget {
  final int id;
  const iget1({super.key,required this.id});



  @override
  State<iget1> createState() => _iget1State();
}

class _iget1State extends State<iget1> {




  Future<dynamic> guess() async{
    var id=widget.id;
    var res=await http.get(Uri.parse("https://fakestoreapi.in/api/products/${id}"));
    var data=jsonDecode(res.body);
    return data;
  }
  void initState(){
    super.initState();
    guess();
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body:  Column(
        children: [
          FutureBuilder(future: guess(), builder: (BuildContext context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            } else if(snapshot.hasError){
              return Text("Error :${snapshot.error}");
            }
            else if(snapshot.hasData){
              var datas = snapshot.data;

              return
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(datas["product"]["image"]))
                      ),
                    ),
                    Text("Title : ${datas["product"]["title"].toString()}"),
                    Text("Price : ${datas["product"]["price"].toString()}"),
                  ],
                );
            }
            else {
              return Text("Something went wrong");
            }
          })
        ],
      ),
    );
  }
}
