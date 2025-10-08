import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final List<Map<String, String>> items;

  const Details({super.key, required this.items});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Details"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(18),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text("${item['name']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Age: ${item['age']}"),
                  Text("Gender: ${item['gender']}"),
                  Text("ID: ${item['id']}"),
                  Text("Year: ${item['year']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
