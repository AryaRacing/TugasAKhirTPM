import 'package:visualisasiSaham/api_service.dart';
import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'register_page.dart';
import 'show_registered_users.dart';
import '../stock_screen.dart';

class LoginPage extends StatefulWidget {
  final ApiService api;

  LoginPage({required this.api});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DatabaseHelper();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;
    List<Map<String, dynamic>> user = await dbHelper.getUserByUsername(username);
    if (user.isNotEmpty && user[0]['password'] == dbHelper.hashPassword(password)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StockScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password. Please try again.'),
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

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _goToShowRegisteredUsersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowRegisteredUsersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 13, 33),
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _goToRegisterPage,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: _goToShowRegisteredUsersPage,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: Text(
              'Show Users',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 10, 14, 33),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _login(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
