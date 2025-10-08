import 'package:api1/fakeapi/cartprovider.dart';
import 'package:api1/fakeapi/provider.dart'; // <- contains ThemeProvider
import 'package:api1/fakeapi/s1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import 's2.dart'; // shop screen

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final cartObject = Provider.of<CartProduct>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    double grandTotal = 0;
    for (var product in cartObject.cart) {
      int qty = (product['quantity'] ?? 1) as int;
      grandTotal += (product['price'] as num) * qty;
    }


    return Scaffold(

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.white30],
            ),
          ),
        ),
        leading:  IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back_ios_new)),
        title: const Text("Shopping Cart"),
        centerTitle: true,
      ),

      // EMPTY CART
      body: cartObject.cart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Your cart is empty",
                style:
                TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
            const SizedBox(height: 20),
            Image.asset("assets/cart.png", height: 180, width: 200),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "You may check out all the available products and buy some in the shop",
                maxLines: 2,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (builder)=>S1()));
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20)),
              child: const Text("Return to shop"),
            )
          ],
        ),
      )

      // CART LIST
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartObject.cart.length,
              itemBuilder: (context, index) {
                var product = cartObject.cart[index];
                product['quantity'] ??= 1;

                double price = (product['price'] as num).toDouble();
                int qty = product['quantity'];
                double total = price * qty;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          height: 130,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            product['image'],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['title'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),

                              // QUANTITY BUTTONS
                              Card(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      padding:
                                      const EdgeInsets.all(0.8),
                                      onPressed: () {
                                        if (product['quantity'] > 1) {
                                          product['quantity']--;
                                          cartObject.notifyListeners();
                                        }
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.minus,
                                        size: 14,
                                      ),
                                    ),
                                    Text("${product['quantity']}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      padding:
                                      const EdgeInsets.all(0.8),
                                      onPressed: () {
                                        product['quantity']++;
                                        cartObject.notifyListeners();
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.plus,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text("In Stock",
                                  style: TextStyle(
                                      color: Colors.lightGreen[400])),

                              Text("Rating: ${product['rating']}/5",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),

                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total: ₹${total.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      cartObject.removeFromCart(
                                          product['id']);
                                    },
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(
                                          color: Colors.red[300]),
                                    ),
                                  )
                                ],
                              ),
                            ],
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

      // BOTTOM BAR
      bottomNavigationBar: cartObject.cart.isEmpty
          ? const SizedBox(height: 10)
          : SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                child: Row(
                  children: [
                    Text(
                      "Grand Total: ",
                      style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Text(
                      "₹ ${grandTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: implement checkout
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green[400],
                    ),
                    child: const Text(
                      "Buy",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
