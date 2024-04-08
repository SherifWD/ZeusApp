import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddMoney(),
    );
  }
}

class AddMoney extends StatefulWidget {
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Same Currency"),
            Tab(text: "International"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SameCurrencyView(),
          InternationalView(),
        ],
      ),
    );
  }
}

class SameCurrencyView extends StatefulWidget {
  @override
  _SameCurrencyViewState createState() => _SameCurrencyViewState();
}

class _SameCurrencyViewState extends State<SameCurrencyView> {
  String? _selectedCurrency;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _accountIdController = TextEditingController();
  double _amount = 0;
  double _fees = 14;

  @override
  void dispose() {
    _amountController.dispose();
    _accountIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("You send"),
          Row(
            children: [
              Expanded(
                child: Text("Available balance: "),
              ),
              Expanded(
                child: Text("EUR or USD"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCurrency,
                  items:
                      <String>['USD', 'EUR', 'GBP', 'JPY'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(Icons.attach_money),
                          SizedBox(width: 5),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCurrency = newValue;
                    });
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  onChanged: (value) {
                    setState(() {
                      _amount = double.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Amount to send",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text("The recipient gets"),
              ),
              Expanded(
                child: Text(
                    "${_amount.toStringAsFixed(2)} ${_selectedCurrency ?? ''}"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text("Payment Fee"),
              ),
              Expanded(
                child: Text(_fees.toString()),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text("Total Amount you pay"),
              ),
              Expanded(
                child: Text("${_amount + _fees}"),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to next step page with form data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NextStepPage(
                    selectedCurrency: _selectedCurrency ?? '',
                    amount: _amount,
                    fees: _fees,
                    accountIdController: _accountIdController,
                  ),
                ),
              );
            },
            child: Text("Next Step"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Show alert for transfer orders over EUR 1 million
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Transfer Information"),
                    content: Text(
                        "Transfer orders over EUR 1 million are processed during the bank's opening hours and can take up to 3 days."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Show Transfer Information"),
          ),
        ],
      ),
    );
  }
}

class InternationalView extends StatefulWidget {
  @override
  _InternationalViewState createState() => _InternationalViewState();
}

class _InternationalViewState extends State<InternationalView> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _accountIdController = TextEditingController();
  double _amount = 0;
  double _fees = 14;

  @override
  void dispose() {
    _amountController.dispose();
    _accountIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Choose Currency: "),
              ),
              Expanded(
                child: Text("EUR or USD"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: 'EUR', // Locked to EUR
                  items: <String>['EUR'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Icon(Icons.attach_money),
                          SizedBox(width: 5),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: null, // Disabled dropdown
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _amount = double.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Amount to send",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text("The recipient gets"),
              ),
              Expanded(
                child: Text(
                    "${_amount.toStringAsFixed(2)} EUR"), // Initial value set to 0.00 EUR
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text("Payment Fee"),
              ),
              Expanded(
                child: Text("$_fees"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text("Total Amount you pay"),
              ),
              Expanded(
                child: Text(_amount == 0 ? '-' : "${_amount + _fees}"),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to next step page with form data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NextStepPage(
                    selectedCurrency: 'EUR', // Locked to EUR
                    amount: _amount,
                    fees: _fees,
                    accountIdController: _accountIdController,
                  ),
                ),
              );
            },
            child: Text("Next Step"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Show alert for transfer orders over EUR 1 million
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Transfer Information"),
                    content: Text(
                        "Transfer orders over EUR 1 million are processed during the bank's opening hours and can take up to 3 days."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Show Transfer Information"),
          ),
        ],
      ),
    );
  }
}

class NextStepPage extends StatelessWidget {
  final String selectedCurrency;
  final double amount;
  final double fees;
  final TextEditingController accountIdController;

  NextStepPage({
    required this.selectedCurrency,
    required this.amount,
    required this.fees,
    required this.accountIdController,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Step"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Person to send to"),
            TextField(
              controller: accountIdController,
              decoration: InputDecoration(
                labelText: "Account ID#",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Submit action
                print("Submitted: ${accountIdController.text}");
                // Call API to submit form data
                submitFormData(selectedCurrency, amount, fees,
                    "${accountIdController.text}");
              },
              child: Text("Submit"),
            ),
            SizedBox(height: 20),
            Text("Selected Currency: $selectedCurrency"),
            Text("Amount: $amount"),
            Text("Fees: $fees"),
          ],
        ),
      ),
    );
  }

  void submitFormData(String selectedCurrency, double amount, double fees,
      String user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Call API to get user data
    String apiUrlUserData = "${Constants.baseUrl}user/getUserData";
    http.Response responseUserData = await http.get(
      Uri.parse(apiUrlUserData),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // print(responseUserData.statusCode);
    // Check response status
    if (responseUserData.statusCode == 200) {
      // Parse user data from response
      Map<String, dynamic> userData = json.decode(responseUserData.body);
      String senderId =
          userData['id'].toString(); // Assuming user ID is stored under 'id'

      // Call API to submit form data
      String apiUrl = "${Constants.baseUrl}transfer";
      // print("Submitting form data to: $apiUrl");

      // Set headers with Bearer token
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Set body with sender_id as hidden variable
      Map<String, dynamic> body = {
        'sender_id': senderId,
        'currency': selectedCurrency,
        'amount': amount,
        'fees': fees,
        'user_id': user_id,
      };

      // Send POST request to API endpoint
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );
      print(body);
      // Check response status
      if (response.statusCode == 200) {
        // Success
        print("Form data submitted successfully");
        print("Response: ${response.body}");
      } else {
        // Error
        print("Error submitting form data: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } else {
      // Error fetching user data
      // print("Error fetching user data: ${responseUserData.statusCode}");
      // print("Response: ${responseUserData.body}");
    }
  }
}

class Constants {
  static const String baseUrl = "https://ambernoak.co.uk/Api/zeus2/public/api";
}
