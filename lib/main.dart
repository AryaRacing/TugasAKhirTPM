import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/welcome_page.dart';
import 'controller/stock_provider.dart';
import 'controller/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
