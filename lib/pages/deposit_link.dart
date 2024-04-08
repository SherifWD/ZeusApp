import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DepositLinkPage extends StatefulWidget {
  @override
  _DepositLinkPageState createState() => _DepositLinkPageState();
}

class _DepositLinkPageState extends State<DepositLinkPage> {
  final TextEditingController _amountController = TextEditingController();
  late String _token;
  List<String> _cardNumbers = [];
  String? _selectedCardNumber;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getToken();
    await _fetchCardNumbers();
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    return _token;
  }

  Future<void> _fetchCardNumbers() async {
    var url = 'https://ambernoak.co.uk/Api/zeus2/public/api/getcards';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        _cardNumbers = List<String>.from(
            responseData['data']['cards'].map((card) => card['card_num']));
      });
      print(_cardNumbers);
    } else {
      // Handle error
    }
  }

  Future<void> _submitRequest() async {
    // Validate amount input
    if (_amountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter an amount.'),
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
    final Map<String, dynamic> requestData = {'amount': _amountController.text};

    // Send the request with authentication token
    final response = await http.post(
      Uri.parse('https://ambernoak.co.uk/Api/zeus2/public/api/request_link'),
      headers: {
        'Authorization': 'Bearer $_token',
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
      print('Request failed with status: ${response.statusCode}');
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
              value: _selectedCardNumber,
              items: _cardNumbers.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCardNumber = newValue;
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
