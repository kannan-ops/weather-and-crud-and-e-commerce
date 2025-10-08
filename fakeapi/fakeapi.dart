import 'package:api1/fakeapi/account.dart';
import 'package:api1/fakeapi/cart.dart';
import 'package:api1/fakeapi/s1.dart';
import 'package:api1/fakeapi/search.dart';
import 'package:api1/fakeapi/wishlist.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int _index = 0;

  final List<Widget> screens = [
    S1(),
    WishlistPage(),
    Cart(),
   Account(),
    Search()
  ];

  void tap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.black,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,color: Colors.black,), label: "Heart"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,color: Colors.black,), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.account_box,color: Colors.black,), label: "Account"),
          BottomNavigationBarItem(icon: Icon(Icons.search,color: Colors.black,), label: "Search"),
        ],
        currentIndex: _index,
        onTap: tap,
      ),
    );
  }
}
