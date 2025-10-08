import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class postApi extends StatefulWidget {
  const postApi({super.key});

  @override
  State<postApi> createState() => _postApiState();
}

class _postApiState extends State<postApi> {

  TextEditingController name = TextEditingController();
  TextEditingController rollno = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController gender = TextEditingController();
  
  Future<dynamic> createStudent() async {
    var res = await http.post(
      Uri.parse("http://92.205.109.210:8051/api/create"),
      headers: {
        'Content-Type':'application/json; charset=utf-8'
      },
      body: jsonEncode({
        "name":name.text,
        "rollno":rollno.text,
        "year":year.text,
        "department":department.text,
        "gender":gender.text
      })
    );
    return res.body;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name"),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText:"Name",
            ),
          ),
          SizedBox(height: 20,),
          Text("Roll No"),
          TextFormField(
            controller: rollno,
            decoration: InputDecoration(
              hintText:"Roll No",
            ),
          ),
          SizedBox(height: 20,),
          Text("Year"),
          TextFormField(
            controller: year,
            decoration: InputDecoration(
              hintText:"Year",
            ),
          ),
          SizedBox(height: 20,),
          Text("Department"),
          TextFormField(
            controller: department,
            decoration: InputDecoration(
              hintText:"Department",
            ),
          ),
          SizedBox(height: 20,),
          Text("Gender"),
          TextFormField(
            controller: gender,
            decoration: InputDecoration(
              hintText:"Gender",
            ),
          ),
          SizedBox(height: 20,),

          ElevatedButton(onPressed: () async {
           await createStudent().whenComplete((){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("added successfully")));
           });

          }, child: Text("Save"))

        ],
      ),
    );
  }
}
