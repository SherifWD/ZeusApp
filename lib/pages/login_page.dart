import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/constants.dart';
import 'package:zeus/pages/root_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPhoneFieldFocused = false;
  bool _isPasswordFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {
        _isPhoneFieldFocused = _phoneFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFieldFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  Future<void> _login() async {
    var url = '${Constants.baseUrl}user/login';

    var credentials = {
      'phone': _phoneController.text,
      'password': _passwordController.text,
    };

    var response = await http.post(Uri.parse(url), body: credentials);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var token = responseData['data']['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RootApp()),
      );
    } else {
      var errorMessage = 'Wrong phone or password';
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 32.0),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            decoration: InputDecoration(
              labelText: 'Phone',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: _isPhoneFieldFocused ? Colors.blue : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: _isPasswordFieldFocused ? Colors.blue : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
