import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../fakeapi/all details.dart';

class Listcrud extends StatefulWidget {
  const Listcrud({super.key});

  @override
  State<Listcrud> createState() => _ListcrudState();
}

class _ListcrudState extends State<Listcrud> {

  TextEditingController Age = TextEditingController();
  TextEditingController Gender = TextEditingController();
  TextEditingController Id = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController Year = TextEditingController();

  List<Map<String, String>> items = [];
  int? editingIndex;

  Future<void> addItem() async {
    String age = Age.text.trim();
    String gender = Gender.text.trim();
    String id = Id.text.trim();
    String name = Name.text.trim();
    String year = Year.text.trim();

    if (age.isNotEmpty &&
        gender.isNotEmpty &&
        id.isNotEmpty &&
        name.isNotEmpty &&
        year.isNotEmpty) {
      setState(() {
        if (editingIndex != null) {
          items[editingIndex!] =
          {
            "age": age,
            "gender": gender,
            "id": id,
            "name": name,
            "year": year
          };
          editingIndex = null;
        } else {
          items.add({
            "age": age,
            "gender": gender,
            "id": id,
            "name": name,
            "year": year
          });
        }
        clearFields();
      });


      await sendToFirebase(age, gender, id, name, year);
    }
  }

  Future<void> sendToFirebase(
      String age, String gender, String id, String name, String year) async {
    var body = jsonEncode({
      "age": age,
      "gender": gender,
      "id": id,
      "name": name,
      "year": year
    });
    try {
      var res = await http.post(Uri.parse(
          "https://classic-18beb-default-rtdb.firebaseio.com/items.json"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: body,
      );
      if (res.statusCode == 200) {
        print(" Data posted: ${res.body}");
      } else {
        print(" Failed to post: ${res.statusCode}");
      }
    } catch (e) {
      print("️ Error: $e");
    }
  }

  void editItem(int index) {
    setState(() {
      Age.text = items[index]["age"] ?? "";
      Gender.text = items[index]["gender"] ?? "";
      Id.text = items[index]["id"] ?? "";
      Name.text = items[index]["name"] ?? "";
      Year.text = items[index]["year"] ?? "";
      editingIndex = index;
    });
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      if (editingIndex != null) {
        editingIndex = null;
        clearFields();
      }

    });
  }

  void clearFields() {
    Age.clear();
    Gender.clear();
    Id.clear();
    Name.clear();
    Year.clear();
  }

  void openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIST CRUD"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: Age,
              decoration: InputDecoration(
                  labelText: editingIndex != null ? "Update age" : "Age",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: Gender,
              decoration: InputDecoration(
                  labelText:
                  editingIndex != null ? "Update gender" : "Gender",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: Id,
              decoration: InputDecoration(
                  labelText: editingIndex != null ? "Update ID" : "ID",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: Name,
              decoration: InputDecoration(
                  labelText: editingIndex != null ? "Update name" : "Name",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: Year,
              decoration: InputDecoration(
                  labelText: editingIndex != null ? "Update year" : "Year",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: addItem,
              child: Text(editingIndex != null ? "Update & Send" : " Send"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text("No data"))
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: openDetails,
                      title: Text(
                        "${items[index]['name']} (${items[index]['age']})",
                      ),
                      subtitle: Text(
                        "Gender: ${items[index]['gender']}, ID: ${items[index]['id']}, Year: ${items[index]['year']}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => editItem(index),
                            icon: Icon(Icons.edit,color: Colors.black,),
                          ),
                          IconButton(
                            onPressed: () => deleteItem(index),
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
