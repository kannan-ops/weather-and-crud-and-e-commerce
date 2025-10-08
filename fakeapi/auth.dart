import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLogin = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;

  Future<http.Response> _submit() async {
    try {
      if (_isLogin) {

        return await http.post(
          Uri.parse("http://92.205.109.210:8070/api/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode({
            "name": _nameController.text.trim(),
            "pwd": _passwordController.text.trim(),
          }),
        );
      } else {

        return await http.post(
          Uri.parse("http://92.205.109.210:8070/api/signup"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode({
            "name": _nameController.text.trim(),
            "mail": _emailController.text.trim(),
            "pwd": _passwordController.text.trim(),
            "gender": _selectedGender ?? "male",
          }),
        );
      }
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
        title: Text(
          _isLogin ? "Log in" : "Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [

            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                    Color(0xFF2C5364),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),


            // Blur Card + Form
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
                              image: AssetImage(_isLogin
                                  ? "assets/login.png"
                                  : "assets/signup.png"),
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
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                                _isLogin ? "Welcome Back!!" : "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _isLogin
                                    ? "Please Login to continue"
                                    : "Please Sign Up to continue",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 25),

                              // Name field
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
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                              ),
                              SizedBox(height: 15),

                              // Email + Gender only for Sign Up
                              if (!_isLogin) ...[
                                TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter Your Email",
                                    icon: Icon(Icons.email, color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                ),
                                SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  onChanged: (val) => setState(() => _selectedGender = val),
                                  items: ["male", "female"]
                                      .map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ))
                                      .toList(),
                                  decoration: InputDecoration(
                                    hintText: "Select Gender",
                                    icon: Icon(Icons.person_outline, color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                  validator: (value) {
                                    if (!_isLogin && (value == null || value.isEmpty)) {
                                      return "Please select gender";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                              ],

                              // Password field
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
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: TextStyle(color: Colors.white54),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              // Submit Button
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

                                    var response = await _submit();
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                    if (response.statusCode == 200 || response.statusCode == 201) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(_isLogin ? "Login Success" : "Signup Success"),
                                        duration: Duration(milliseconds: 500),
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
                                  _isLogin ? "Log in" : "Sign Up",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 15),

                              // Toggle Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_isLogin ? "Don't have an account?" : "Already have an account?"),
                                  TextButton(
                                    onPressed: () => setState(() => _isLogin = !_isLogin),
                                    child: Text(
                                      _isLogin ? "Sign Up" : "Login",
                                      style: TextStyle(color: Colors.blue[300], fontWeight: FontWeight.bold),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
