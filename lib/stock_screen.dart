import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock_provider.dart';
import 'stock_chart_screen.dart'; // Import StockChartScreen

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _controller = TextEditingController();

  void _searchStocks() {
    final provider = Provider.of<StockProvider>(context, listen: false);
    provider.searchStocks(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 13, 33),
        title: Text(
          'Stock App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 10, 14, 33),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Stock Symbol',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchStocks,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Search Stocks',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Consumer<StockProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return CircularProgressIndicator();
                } else if (provider.stocks.isEmpty) {
                  return Text(
                    'No stocks found',
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: provider.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = provider.stocks[index];
                        return ListTile(
                          title: Text(
                            stock.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            stock.symbol,
                            style: TextStyle(color: Colors.white),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
