import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class getSingle extends StatefulWidget {
  final int id;
  const getSingle({super.key, required this.id});

  @override
  State<getSingle> createState() => _getSingleState();
}

class _getSingleState extends State<getSingle> {
  
  Future<dynamic> fetchsingledata() async {
    var id = widget.id;
    var res = await http.get(Uri.parse("https://fakestoreapi.in/api/products/${id}"));
    var data = jsonDecode(res.body);
    return data;
  }

  void initState(){
    super.initState();
    fetchsingledata();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          FutureBuilder(future: fetchsingledata(), builder: (BuildContext context, snapshot){
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
