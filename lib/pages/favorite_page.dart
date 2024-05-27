import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/stock_provider.dart';
import 'stock_chart_screen.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    final favoriteStocks = provider.favoriteStocks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 14, 33), // Background color: dark blue
        title: Text(
          'Favorite Stocks',
          style: TextStyle(color: Colors.white), // Text color: white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Back button color: white
      ),
      backgroundColor: Color.fromARGB(255, 10, 14, 33),
      body: ListView.builder(
        itemCount: favoriteStocks.length,
        itemBuilder: (context, index) {
          final stock = favoriteStocks[index];
          return ListTile(
            title: Text(
              stock.name,
              style: TextStyle(color: Colors.white), // Text color: white
            ),
            subtitle: Text(
              stock.symbol,
              style: TextStyle(color: Colors.white), // Text color: white
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockChartScreen(symbol: stock.symbol),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
