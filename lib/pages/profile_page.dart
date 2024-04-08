import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/theme/color.dart';
import 'package:zeus/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = '${Constants.baseUrl}user/getUserData';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer $token', // Include JWT token in the request headers
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body)['data'];
      });
    } else {
      // Handle error
      print('Failed to fetch user data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.0),
                  buildTextField('Name', Icons.person, userData!['name']),
                  buildTextField('Email', Icons.email, userData!['email']),
                  buildTextField(
                      'Birth Date', Icons.cake, userData!['birthdate']),
                  buildTextField('Phone', Icons.phone, userData!['phone']),
                  buildTextField(
                      'Address', Icons.location_on, userData!['address']),
                  buildTextField(
                      'ID Number', Icons.assignment, userData!['id_number']),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for Edit Profile button
                    },
                    child: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      backgroundColor: Colors.blue.shade200,
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(String label, IconData icon, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}
