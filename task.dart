import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late Future<List<dynamic>> futureData;

  Future<List<dynamic>> guess() async {
    var res = await http.get(Uri.parse("http://universities.hipolabs.com/search?country=United+States"),);
    return jsonDecode(res.body);
  }

  @override
  void initState() {
    super.initState();
    futureData = guess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return  Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            var universities = snapshot.data!;
            return ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                var uni = universities[index];
                return ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Web pages: ${uni["web_pages"]}"),
                      Text("State province: ${uni["state-province"]}"),
                      Text("Domains: ${uni["domains"]}"),
                      Text("alpha two code: ${uni["alpha_two_code"]}"),
                      Text("country: ${uni["country"]}"),
                      Text("name: ${uni["name"]}"),
                    ],
                  ),
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
