import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'cart.dart';
import 'wishlist.dart';

List<Map<String, dynamic>> cartList = [];

class s2 extends StatefulWidget {
  final int id;
  const s2({super.key, required this.id});

  @override
  State<s2> createState() => _s2State();
}

class _s2State extends State<s2> {
  Map<String, dynamic>? product;
  int count = 1;

  Future<dynamic> guess() async {
    var res = await http.get(
      Uri.parse("https://fakestoreapi.com/products/${widget.id}"),
    );
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      product = data;
      return data;
    } else {
      throw Exception("Failed to load product");
    }
  }

  @override
  void initState() {
    super.initState();
    guess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product ${widget.id}"),
      ),
      body: FutureBuilder(
        future: guess(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            var data = snapshot.data as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        data["image"] ?? "",
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Title: ${data["title"]}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Price: \$${data["price"]}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Description: ${data["description"]}"),
                    const SizedBox(height: 8),
                    Text(
                        "Rating: ${data["rating"]["rate"]} (${data["rating"]["count"]} reviews)"),
                    const SizedBox(height: 8),
                    const Text(
                      "Quantity",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (count > 1) {
                                setState(() {
                                  count--;
                                });
                              }
                            },
                            icon: const Icon(CupertinoIcons.minus,
                                color: Colors.black)),
                        Text(
                          "$count",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                count++;
                              });
                            },
                            icon: const Icon(CupertinoIcons.plus,
                                color: Colors.black, size: 14)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            int index = cartList.indexWhere(
                                    (item) => item['id'] == data['id']);

                            if (index != -1) {
                              cartList[index]['quantity'] =
                                  (cartList[index]['quantity'] as int) + count;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Quantity Updated")),
                              );
                            } else {
                              cartList.add({
                                "id": data['id'] as int,
                                "title": data['title'] as String,
                                "price": (data['price'] as num).toDouble(),
                                "image": data['image'] as String,
                                "quantity": count,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Added to Cart")),
                              );
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Cart()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                          ),
                          child: Text(
                            "Add to cart - Rs.${((data['price'] as num) * count).toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),


                        Consumer<WishlistProduct>(
                          builder: (context, wishlistProvider, child) {
                            return IconButton(
                              icon: Icon(
                                wishlistProvider.containsProduct(data['id'])
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if (wishlistProvider
                                    .containsProduct(data['id'])) {
                                  wishlistProvider
                                      .removeFromWishlist(data['id']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                        Text("Removed from Wishlist")),
                                  );
                                } else {
                                  wishlistProvider.addToWishlist(data);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to Wishlist")),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 130, vertical: 20),
                      ),
                      child: const Text(
                        "Buy It Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Text("Something went wrong");
          }
        },
      ),
    );
  }
}
