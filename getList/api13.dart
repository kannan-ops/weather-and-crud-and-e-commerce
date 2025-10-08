import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api13 extends StatefulWidget {
  const Api13({super.key});

  @override
  State<Api13> createState() => _Api13State();
}

class _Api13State extends State<Api13> {
  late Future<List<dynamic>> futureData;

  Future<List<dynamic>> guess() async {
    var res = await http.get(
      Uri.parse("http://universities.hipolabs.com/search?country=United+States"),
    );
    return jsonDecode(res.body);
  }

  @override
  void initState() {
    super.initState();
    futureData = guess();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var universities = snapshot.data!;
            return ListView.builder(
              itemCount: universities.length,
              itemBuilder: (context, index) {
                var uni = universities[index];
                return ListTile(
                  title: Text(uni["name"]),
                  subtitle: Text("Domain: ${uni["domains"][0]}"),
                );
              },
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}
