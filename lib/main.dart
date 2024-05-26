import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'welcome_page.dart'; // Import WelcomePage
import 'stock_provider.dart'; // Import the StockProvider
import 'api_service.dart'; // Import ApiService

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Buat instance ApiService
    final ApiService apiService = ApiService();

    return ChangeNotifierProvider(
      create: (_) => StockProvider(),
      child: MaterialApp(
        title: 'Stock App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage(api: apiService), // Berikan instance ApiService ke WelcomePage
      ),
    );
  }
}
