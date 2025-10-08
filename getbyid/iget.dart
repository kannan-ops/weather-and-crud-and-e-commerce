import 'dart:convert';

import 'package:api1/getbyid/iget1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class iget extends StatefulWidget {
  const iget({super.key});

  @override
  State<iget> createState() => _igetState();
}

class _igetState extends State<iget> {

  Future<dynamic> god() async{

    try{
    var res=await http.get(Uri.parse("https://fakestoreapi.in/api/products"));
    if(res.statusCode==200 || res.statusCode==201){
      var product=jsonDecode(res.body);
      return product;
    }
    }
    catch(e){
      return Text(e.toString());
    }
  }
  void initState(){
    super.initState();
    god();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(future: god(), builder:(BuildContext context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              else if(snapshot.hasError){
                return Text("Error  :${snapshot.error}");
              }
              else if(snapshot.hasData){
            var data=snapshot.data;
            var products=data["products"];
            return Container(
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder:(BuildContext context ,int index){
            return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => iget1    (id:products[index]["id"] ,)));
            },
            child:Column(
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
            )
        
            );
            })
        
            );
            }else {
                return Text("something went wrong");
              }
            })
          ],
        ),
      ),
    );
  }
}
