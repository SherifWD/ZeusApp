import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DepositUSDDPage extends StatefulWidget {
  @override
  _DepositUSDDPageState createState() => _DepositUSDDPageState();
}

class _DepositUSDDPageState extends State<DepositUSDDPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _networkController = TextEditingController();
  late String _token;
  String? _selectedCard;
  List<String> _cards = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    // _getToken();
    // _fetchCards();
  }

  Future<void> _initializeData() async {
    await _getToken();
    await _fetchCardNumbers();
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<void> _fetchCardNumbers() async {
    var url = 'https://ambernoak.co.uk/Api/zeus2/public/api/getcards';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _cards = List<String>.from(
            responseData['data']['cards'].map((card) => card['card_num']));
      });
      print(_cards);
    } else {
      // Handle error
    }
  }

  Future<void> _submitRequest() async {
    // Validate input fields
    if (_amountController.text.isEmpty ||
        _platformController.text.isEmpty ||
        _networkController.text.isEmpty ||
        _selectedCard == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Prepare the request body
    final Map<String, dynamic> requestData = {
      'amount': _amountController.text,
      'platform': _platformController.text,
      'network': _networkController.text,
      'card_num': _selectedCard,
    };

    // Send the request with authentication token
    final response = await http.post(
      Uri.parse('https://ambernoak.co.uk/Api/zeus2/public/api/request_usdd'),
      headers: {
        'Authorization':
            'Bearer $_token', // Include JWT token in the request headers
      },
      body: requestData,
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final bool result = responseData['result'];
    // Handle response
    if (result) {
      print(response.body);
      // Request successful
      // You can handle the response accordingly
      print('Request successful');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Requested Successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Request failed
      print('Failed to submit request: ${responseData['msg']}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit request:\n${responseData['msg']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCard,
              items: _cards.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCard = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Card',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _platformController,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter Platform',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _networkController,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter Network',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text('Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
