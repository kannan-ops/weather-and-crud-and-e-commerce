import 'package:api1/fakeapi/account.dart';
import 'package:api1/fakeapi/category.dart';
import 'package:api1/fakeapi/fakeapi.dart';
import 'package:api1/fakeapi/search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'fakeapi/a1.dart';
import 'fakeapi/auth.dart';
import 'fakeapi/cartprovider.dart';
import 'fakeapi/more.dart';
import 'fakeapi/sign.dart';
import 'getList/weatherapi.dart';
import 'fakeapi/provider.dart';
import 'fakeapi/cart.dart';
import 'fakeapi/s1.dart';
import 'fakeapi/wishlist.dart';
import 'firebase_options.dart';

Future<void> main() async {


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProduct()),
        ChangeNotifierProvider(create: (_) => WishlistProduct()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Shopping App',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          home: Bottom(),
        );
      },
    );
  }
}
