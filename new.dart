import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  List a= [];
  
  get()  async
  {
    final res = await http.get(Uri.parse("https://api.escuelajs.co/api/v1/products"));
    
    a = jsonDecode(res.body);
    
    setState(() {
      
    });
    
    
  }

  @override
  void initState() {
    get();
    // TODO: implement initState
    super.initState();
  }
  
  
  //"https://api.escuelajs.co/api/v1/products"
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: a.length,
          itemBuilder: (BuildContext,index){
        return ListTile(
          title: Text(a[index]['title']),
          leading: Image.network(a[index]['category']['image']),
        );
      }),
    );
  }
}
