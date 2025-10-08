import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'getsingle.dart';

class getById extends StatefulWidget {
  const getById({super.key});

  @override
  State<getById> createState() => _getByIdState();
}

class _getByIdState extends State<getById> {


  Future<dynamic> fetchproducts () async {
    try{
      var res = await http.get(Uri.parse("https://fakestoreapi.in/api/products"));
      if(res.statusCode == 200 || res.statusCode == 201){
        var product = jsonDecode(res.body);
        return product;
      }
    }
    catch(e){
      return Text(e.toString());
    }
  }

  void initState() {
    super.initState();
    fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(future:fetchproducts(), builder: (BuildContext context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              } else if(snapshot.hasError){
                return Text("Error :${snapshot.error}");
              }
              else if(snapshot.hasData){
                var datas = snapshot.data;
                var products = datas["products"];
                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:products.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => getSingle(id:products[index]["id"] ,)));
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(products[index]["image"]))
                                ),
                              ),
                              Text("Title : ${products[index]["title"].toString()}"),
                              Text("Price : ${products[index]["price"].toString()}"),
                            ],
                          ),
                        ),
                      );
                    },),
                );
              }
              else {
                return Text("Something went wrong");
              }
            })
          ],
        ),
      ),
    );
  }
}
