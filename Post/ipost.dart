import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ipost extends StatefulWidget {
  const ipost({super.key});

  @override
  State<ipost> createState() => _ipostState();
}

class _ipostState extends State<ipost> {
  bool there = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController rollno = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController gender = TextEditingController();

  Future<dynamic> audio() async {
    try {
      var res = await http.post(
        Uri.parse("http://92.205.109.210:8051/api/create"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          "name": name.text,
          "rollno": rollno.text,
          "year": year.text,
          "department": department.text,
          "gender": gender.text
        }),
      );
      var bodyData=jsonDecode(res.body);
      print(res.statusCode);

      if(res.statusCode==200||res.statusCode==201){
        name.clear();

        return bodyData;
      }
      else{
        throw Exception("Failed to add data");
      }


    }
    catch(e) {
    throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post API",
          style: TextStyle(
              color: Colors.purple,
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(Icons.post_add, size: 40, color: Colors.black),
        ],
      ),
      body: Form(
        key: _formKey,
        child:
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.orange
          ),
          child:  Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  hintText: "name",
                  border: OutlineInputBorder(),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return "Enter valid name";
                  }
                  return null;
                },
                onChanged: (i){
                  setState(() {
                    name.text.isNotEmpty && rollno.text.isNotEmpty && year.text.isNotEmpty && department.text.isNotEmpty ? there= true:there=false;
                  });
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: rollno,
                decoration: InputDecoration(
                  hintText: "roll no",
                  border: OutlineInputBorder(),
                ),
                validator: (input) {
                  if (!RegExp(r'^[0-9]+$').hasMatch(input ?? "")) {
                    return "Enter valid rollno";
                  }
                  return null;
                },
                onChanged: (i){
                  setState(() {
                    name.text.isNotEmpty && rollno.text.isNotEmpty && year.text.isNotEmpty && department.text.isNotEmpty ? there= true:there=false;
                  });
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: year,
                decoration: InputDecoration(
                  hintText: "year",
                  border: OutlineInputBorder(),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return "Enter valid year";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: department,
                decoration: InputDecoration(
                  hintText: "department",
                  border: OutlineInputBorder(),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return "Enter valid department";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: gender,
                decoration: InputDecoration(
                  hintText: "gender",
                  border: OutlineInputBorder(),
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return "Enter valid gender";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    await audio().whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ok success")));
                    });
                  }
                },
                child: Text(
                  "ok",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }
}
