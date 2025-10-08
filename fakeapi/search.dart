import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController ctrl = TextEditingController();
  List<dynamic> filteredProducts = [];
  bool _loading = false;

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = [];
      });
      return;
    }

    setState(() {
      _loading = true;
    });

   final res=await http.get(Uri.parse("https://fakestoreapi.com/products"));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);

      setState(() {
        filteredProducts = data
            .where((product) =>
            product["title"].toLowerCase().contains(query.toLowerCase()))
            .toList();
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _resetSearch() {
    setState(() {
      ctrl.clear();
      filteredProducts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Products",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: _resetSearch,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: ctrl,
              onChanged: (value) {
                _searchProducts(value); // 🔥 live search
              },
              decoration: const InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          /// 🔥 Search Results List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                ? const Center(child: Text("No products found"))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      product["image"],
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product["title"]),
                    subtitle: Text("\$${product["price"]}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
