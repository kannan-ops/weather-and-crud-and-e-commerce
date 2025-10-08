import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api14   extends StatefulWidget {
  const Api14({super.key});

  @override
  State<Api14> createState() => _Api14State();
}

class _Api14State extends State<Api14> {
  late Future<dynamic> futureData;

  Future<dynamic> fill() async {
    var res = await http.get(Uri.parse("https://randomuser.me/api/"));
    var the=jsonDecode(res.body);
    return the;
  }

  @override
  void initState() {
    super.initState();
    futureData = fill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureData,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var the = snapshot.data;
            var results = the["results"];
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                children: [
                  Text("Gender   :${results[index]["gender"]}"),
                  Text("title  :${results[index]["name"]["title"]}"),
                  Text(" first   :${results[index]["name"]["first"]}"),
                  Text("last   : ${results[index]["name"]["last"]}"),
                  Text("Location   :${results[index]["location"]["street"]["number"]}"),
                  Text("Location   :${results[index]["location"]["street"]["name"]}"),



                  Text("seed   :${the["info"]["seed"]}"),
                  Text("result   :${the["info"]["results"]}"),
                  Text("Info   :${the["info"]["page"]}"),
                  Text("Result   :${the["info"]["version"]}"),







                ],
                );
              },
            );
          } else {
            return  Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}
