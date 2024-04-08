import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepositBankPage extends StatefulWidget {
  @override
  _DepositBankPageState createState() => _DepositBankPageState();
}

class _DepositBankPageState extends State<DepositBankPage> {
  final TextEditingController _invoiceNumberController =
      TextEditingController();
  String _selectedFile = ''; // File path or name of the attached invoice

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            buildTextField(
                'Account Number', Icons.account_balance, "2265001020143001015"),
            buildTextField('Branch Number ', Icons.numbers, "226"),
            buildTextField(
                'Branch Name ', Icons.near_me, "مصطفي كامل اسكندريه"),
            buildTextField('Currency ', Icons.currency_pound, "EGP"),
            buildTextField(
                'IBAN ', Icons.back_hand, "EG520003022650010201430010150"),
            SizedBox(height: 16.0),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Attach Invoice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _attachInvoice,
                      icon: Icon(Icons.attach_file),
                      label: Text(_selectedFile.isNotEmpty
                          ? 'View Invoice'
                          : 'Attach Invoice'),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _invoiceNumberController,
                      decoration: InputDecoration(
                        labelText: 'Invoice Number',
                        prefixIcon: Icon(Icons.note),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
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
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }

  void _attachInvoice() async {
    // Implement logic to attach invoice (e.g., open file picker)
    // For simplicity, I'll just set a mock file name here
    setState(() {
      _selectedFile = 'Invoice.pdf'; // Mock file name
    });
  }

  void _submitData() async {
    // Get the invoice number from the text field
    String invoiceNumber = _invoiceNumberController.text;

    // Implement API call to submit data
    final response = await http.post(
      Uri.parse('https://ambernoak.co.uk/Api/zeus2/public/api/getcards'),
      body: {'invoice_number': invoiceNumber},
    );

    // Handle API response accordingly
    if (response.statusCode == 200) {
      // Submission successful, show success message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data submitted successfully.'),
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
    } else {
      // Submission failed, show error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit data. Please try again.'),
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
  void dispose() {
    _invoiceNumberController.dispose();
    super.dispose();
  }
}
