import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<http.Response> loginUser() async {
    try {
      final response = await http.post(
        Uri.parse("http://92.205.109.210:8070/api/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "pwd": _passwordController.text.trim(),
        }),
      );
      print("Response: ${response.body}");
      return response;
    } catch (error) {
      throw Exception("API Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.login),
        ),
        title: Text(
          "Log-in",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 70),
                        Container(
                          height: 150,
                          width: 350,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/login.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 340,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Welcome Back!!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Please Login in to continue",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 25),
                              // Name Field
                              TextFormField(
                                controller: _nameController,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your name";
                                  } else if (RegExp(
                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]',
                                  ).hasMatch(value)) {
                                    return "Please enter a valid name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Your Name",
                                  icon: Icon(Icons.person, color: Colors.white70),
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter the password";
                                  }
                                  if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                  ).hasMatch(value)) {
                                    return "Password must be 8+ chars with letters, numbers & special char.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter Your Password",
                                  icon: Icon(Icons.lock, color: Colors.white70),
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              // Login Button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Submitting..."),
                                      duration: Duration(milliseconds: 500),
                                    ));

                                    var response = await loginUser();

                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    if (response.statusCode == 200 ||
                                        response.statusCode == 201) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Login Success..."),
                                        duration: Duration(milliseconds: 300),
                                      ));


                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("User not valid!!"),
                                      ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account?"),
                                  TextButton(
                                    onPressed: () {


                                    },
                                    child: Text(
                                      "Signin",
                                      style: TextStyle(
                                        color: Colors.blue[300],
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
