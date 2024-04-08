import 'package:flutter/material.dart';

class DepositVodafonePage extends StatefulWidget {
  @override
  _DepositVodafonePageState createState() => _DepositVodafonePageState();
}

class _DepositVodafonePageState extends State<DepositVodafonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vodafone Cash'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            buildTextField(
                'Account Owner Name', Icons.near_me, "Sherif Ahmed ElShahawy"),
            buildTextField('Vodafone Cash ', Icons.numbers, "201007711358"),
            // buildTextField('Birth Date', Icons.cake, "01-01-1990"),
            // buildTextField(
            //     'Branch Name ', Icons.near_me, "مصطفي كامل اسكندريه"),
            // buildTextField('Currency ', Icons.currency_pound, "EGP"),
            // buildTextField(
            //     'IBAN ', Icons.back_hand, "EG520003022650010201430010150"),
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
          labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight
                  .bold), // Set label text color to black and weight to bold
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
            fontWeight:
                FontWeight.bold), // Set text color to black and weight to bold
        controller: TextEditingController(text: value),
      ),
    );
  }
}
