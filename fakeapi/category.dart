import 'dart:convert';
import 'package:api1/fakeapi/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'cartprovider.dart';
List<dynamic> catList = [];
int selectedIndex = 0;
List<dynamic> selectedProduct = [];
class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  int count = 1;
Set<int> likedProducts={};
bool isSearching=false;
  Future<void> getData() async {
    try {
      var apiRes = await http.get(
        Uri.parse('https://fakestoreapi.com/products/categories'),
      );
      if (apiRes.statusCode == 200) {
        setState(() {
          catList = jsonDecode(apiRes.body);
        });
        if (catList.isNotEmpty) {
          getProduct(catList[0]);
        }
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (error) {
      debugPrint("Error in getData: $error");
    }
  }

  Future<void> getProduct(String category) async {
    try {
      var apiRes = await http.get(
        Uri.parse('https://fakestoreapi.com/products/category/$category'),
      );
      if (apiRes.statusCode == 200) {
        setState(() {
          selectedProduct = jsonDecode(apiRes.body);
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (error) {
      debugPrint("Error in getProduct: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var cartObject = Provider.of<CartProduct>(context);
    final likedObject = Provider.of<WishlistProduct>(context);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black87, Colors.white30]),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Categories"),
        centerTitle: true,
      ),
      body: catList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Row(
        children: [
          // Left category list
          Container(
            width: 100,
            child: ListView.builder(
              itemCount: catList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    getProduct(catList[index]);
                  },
                  child: Container(
                    color: selectedIndex == index
                        ? Colors.grey[300]
                        : Colors.transparent,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(Icons.category, size: 40),
                        const SizedBox(height: 5),
                        Text(
                          "${catList[index]}",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Right products grid
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // category title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    catList[selectedIndex].toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: selectedProduct.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: selectedProduct.length,
                    itemBuilder: (context, index) {
                      var product = selectedProduct[index];
                      bool isInWishlist = likedObject.wishlist
                          .any((item) => item['id'] == product['id']);

                      bool isInCart = cartObject.cart
                          .any((item) => item['id'] == product['id']);

                      double price = product['price'] * 1.0;
                      double discount = 10; // mock discount
                      double finalPrice =
                          price - (price * discount / 100);

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Image.network(
                                  product['image'].toString(),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  loadingBuilder: (ctx, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Title
                              Text(
                                product['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Price
                              Text(
                                "Rs. ${price.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 12,
                                  decoration:
                                  TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "Rs. ${finalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const Spacer(),

                              // Add/Remove Cart
                              OutlinedButton(
                                onPressed: () {
                                  if (isInCart) {
                                    cartObject.removeFromCart(
                                        product['id']);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Removed from Cart")),
                                    );
                                  } else {
                                    Map<String, dynamic> cartItems =
                                    {
                                      'id': product['id'],
                                      'title': product['title'],
                                      'image': product['image'],
                                      'price': price,
                                      'quantity': count,
                                    };
                                    cartObject.addToCart(cartItems);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text("Added to Cart")),
                                    );
                                  }
                                },
                                child: Text(
                                  isInCart
                                      ? "Remove from Cart"
                                      : "Add to Cart",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
