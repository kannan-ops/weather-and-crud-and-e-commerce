import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  TextEditingController ctrl1 = TextEditingController();
  late Future<Map<String, dynamic>>? futureWeather;

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    const apiKey = "91bbbde36bb4a636b2160e9720498ff9";
    final res = await http.get(Uri.parse("api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("City not found");
    }
  }

  @override
  void initState() {
    super.initState();
    futureWeather = null;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
          backgroundColor: Colors.lightBlue),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/getty.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: ctrl1,
                decoration: const InputDecoration(
                  labelText: "Enter City Name",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      futureWeather = fetchWeather(value.trim());
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(height: 100,),
              ElevatedButton(
                onPressed: () {
                  if (ctrl1.text.trim().isNotEmpty) {
                    setState(() {
                      futureWeather = fetchWeather(ctrl1.text.trim());
                    });
                  }
                },
                child: const Text("Get Weather",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 20),
              if (futureWeather != null)
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: futureWeather,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        var data = snapshot.data!;
                        var cityName = data["name"];
                        var temp = data["main"]["temp"];
                        var condition = data["weather"][0]["description"];

                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 200),
                              Container(
                                height: 150,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage("assets/"),
                                    fit: BoxFit.contain,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cityName,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black,fontWeight:FontWeight.bold),
                                    ),
                                    Text(
                                      "$temp°C",
                                      style: const TextStyle(
                                          fontSize: 40, color: Colors.black,fontWeight:FontWeight.bold),
                                    ),
                                    Text(
                                      condition,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black,fontWeight:FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox(); // Show nothing if no data
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
