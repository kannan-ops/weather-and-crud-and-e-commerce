import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api3 extends StatefulWidget {
  const Api3({super.key});

  @override
  State<Api3> createState() => _Api3State();
}

class _Api3State extends State<Api3> {
  late Future<dynamic> futureDog;

  Future<dynamic> name() async {
    var res = await http.get(Uri.parse("https://dog.ceo/api/breeds/image/random"));
    var the = jsonDecode(res.body);
    return the;
  }

  @override
  void initState() {
    super.initState();
    futureDog = name();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: futureDog,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              var the = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("MESSAGE: ${the["message"]}"),
                  SizedBox(height: 10),
                  Image.network(the["message"]),
                  SizedBox(height: 10),
                  Text("STATUS: ${the["status"]}"),
                ],
              );
            } else {
              return Text("ok");
            }
          },
        ),
      ),
    );
  }
}
