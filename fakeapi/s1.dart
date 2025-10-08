import 'dart:convert';
import 'package:api1/fakeapi/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'cart.dart';
import 'wishlist.dart';
import 's2.dart';

class S1 extends StatefulWidget {
  const S1({super.key});

  @override
  State<S1> createState() => _S1State();
}

class _S1State extends State<S1> {
  late Future<List<dynamic>> futureProducts;
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool _isLoading = false;
  bool _isSearching = false;
  TextEditingController searchCtrl = TextEditingController();

  Future<List<dynamic>> fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      var res = await http.get(Uri.parse("https://dummyjson.com/products"));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        allProducts = data;
        filteredProducts = List.from(allProducts);
        return data;
      } else {
        throw ('Failed to load products');
      }
    } catch (e) {
      throw ('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _searchProducts(String query) {
    setState(() {
      filteredProducts = query.isEmpty
          ? List.from(allProducts)
          : allProducts
          .where((p) =>
          p['title'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProduct>();
    final wishlistProvider = context.watch<WishlistProduct>();

    return Scaffold(

      drawer: Drawer(
        backgroundColor: Colors.black87,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  "More Options",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text("Home", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>S1()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: Colors.white),
                title: const Text("Categories", style: TextStyle(color: Colors.white)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Categories Clicked")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text("Wishlist", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WishlistPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.white),
                title: const Text("Cart", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Cart()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text("Settings", style: TextStyle(color: Colors.white)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Settings Clicked")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text("Profile", style: TextStyle(color: Colors.white)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile Clicked")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.support_agent, color: Colors.white),
                title: const Text("Support", style: TextStyle(color: Colors.white)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Support Clicked")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text("About Us", style: TextStyle(color: Colors.white)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("About Us Clicked")),
                  );
                },
              ),
            ],
          ),
        ),
      ),



      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: _isSearching
            ? TextField(
          controller: searchCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
          ),
          onChanged: _searchProducts,
        )
            : const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  searchCtrl.clear();
                  filteredProducts = List.from(allProducts);
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Cart()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<dynamic>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products'));
          }

          final products = filteredProducts;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                var p = products[index];
                final int id = p['id'] is int
                    ? p['id']
                    : int.tryParse(p['id'].toString()) ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => s2(id: id)),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Image.network(
                            p['image'].toString(),
                            fit: BoxFit.contain,
                            width: double.infinity,
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              p['title'].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${p['price'].toString()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (cartProvider.containsProduct(id)) {
                                  cartProvider.incrementQuantity(id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content:
                                        Text("Quantity Updated")),
                                  );
                                } else {
                                  cartProvider.addToCart(
                                      {...p, "quantity": 1});
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to Cart")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text("Add To Cart"),
                            ),
                            IconButton(
                              icon: Icon(
                                wishlistProvider.containsProduct(id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if (wishlistProvider.containsProduct(id)) {
                                  wishlistProvider.removeFromWishlist(id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Removed from Wishlist")),
                                  );
                                } else {
                                  wishlistProvider.addToWishlist(p);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to Wishlist")),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

