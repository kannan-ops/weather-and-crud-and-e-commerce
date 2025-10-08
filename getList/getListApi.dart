import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class getlistApi extends StatefulWidget {
  const getlistApi({super.key});

  @override
  State<getlistApi> createState() => _getlistApiState();
}

class _getlistApiState extends State<getlistApi> {

  late Future<dynamic> _future;

  Future<dynamic> fetchdata() async {
    var res = await http.get(Uri.parse("https://api.nationalize.io?name=nathaniel"));
    var data = jsonDecode(res.body);
    return data;
  }

  void initState() {
    super.initState();
    _future = fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(future: _future, builder: (BuildContext context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            } else if(snapshot.hasError){
              return Text("Error :${snapshot.error}");
            }
            else if(snapshot.hasData){
              var data = snapshot.data;
              var countries = data["country"];
              return Column(
                children: [
                  Text("Count : ${data["count"].toString()}"),
                  Text("Name : ${data["name"].toString()}"),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount:countries.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: [
                          Text("Country id : ${countries[index]["country_id"]}"),
                          Text("Probability : ${countries[index]["probability"]}"),
                        ],
                      );
                  },)
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
