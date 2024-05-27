import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/stock_provider.dart';
import 'stock_chart_screen.dart';
import '../controller/session_manager.dart';
import 'login_page.dart';
import '../controller/api_service.dart'; 
import 'favorite_page.dart';

class StockScreen extends StatefulWidget {
  final ApiService api;

  StockScreen({required this.api});

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _controller = TextEditingController();
  final SessionManager sessionManager = SessionManager();

  void _searchStocks() {
    final provider = Provider.of<StockProvider>(context, listen: false);
    provider.searchStocks(_controller.text);
  }

  void _toggleFavorite(String symbol) {
    final provider = Provider.of<StockProvider>(context, listen: false);
    provider.toggleFavorite(symbol);
  }

  void _logout() async {
    await sessionManager.clearSession(); // Hapus informasi sesi saat logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(api: widget.api)),
    );
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
            Text(
              'Visualisasi Saham Yang Anda Cari, dan Masukan Saham Favorit Anda Untuk Memantau Market',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
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
                          trailing: IconButton(
                            icon: Icon(
                              provider.favoriteStocks.contains(stock) ? Icons.favorite : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _toggleFavorite(stock.symbol),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _logout,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Navigate to home or any other screen
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritePage()), // Go to FavoritePage
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
