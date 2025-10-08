import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistProduct with ChangeNotifier {
  final List<Map<String, dynamic>> _wishlist = [];

  List<Map<String, dynamic>> get wishlist => _wishlist;


  void addToWishlist(Map<String, dynamic> product) {
    if (!_wishlist.any((item) => item['id'] == product['id'])) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(int id) {
    _wishlist.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  bool containsProduct(int id) {
    return _wishlist.any((item) => item['id'] == id);
  }
}

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProduct>(); // ✅ fixed

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: wishlistProvider.wishlist.isEmpty
          ? const Center(child: Text("No items in wishlist"))
          : ListView.builder(
        itemCount: wishlistProvider.wishlist.length,
        itemBuilder: (context, index) {
          final product = wishlistProvider.wishlist[index];
          return ListTile(
            leading: Image.network(
              product['image'],
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product['title']),
            subtitle: Text("\$${product['price']}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                wishlistProvider.removeFromWishlist(product['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Removed from Wishlist"),
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
