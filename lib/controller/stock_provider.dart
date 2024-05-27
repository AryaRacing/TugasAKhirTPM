import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../stock_model.dart';

class StockProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Stock> _stocks = [];
  List<HistoricalData> _historicalData = [];
  List<Stock> _favoriteStocks = [];
  bool _isLoading = false;

  // SharedPreferences keys
  static const String _favoriteStocksKey = 'favoriteStocks';

  List<Stock> get stocks => _stocks;
  List<HistoricalData> get historicalData => _historicalData;
  List<Stock> get favoriteStocks => _favoriteStocks;
  bool get isLoading => _isLoading;

  void toggleFavorite(String symbol) {
    final existingIndex = _favoriteStocks.indexWhere((stock) => stock.symbol == symbol);
    if (existingIndex >= 0) {
      _favoriteStocks.removeAt(existingIndex);
    } else {
      final stock = _stocks.firstWhere((stock) => stock.symbol == symbol);
      _favoriteStocks.add(stock);
    }
    _saveFavoriteStocks();
    notifyListeners();
  }

  Future<void> loadFavoriteStocks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteSymbols = prefs.getStringList(_favoriteStocksKey);
    if (favoriteSymbols != null) {
      _favoriteStocks = _stocks.where((stock) => favoriteSymbols.contains(stock.symbol)).toList();
    }
  }

  Future<void> _saveFavoriteStocks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteSymbols = _favoriteStocks.map((stock) => stock.symbol).toList();
    prefs.setStringList(_favoriteStocksKey, favoriteSymbols);
  }

  Future<void> searchStocks(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _stocks = await _apiService.searchStocks(query);
      await loadFavoriteStocks();
    } catch (e) {
      _stocks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistoricalData(String symbol) async {
    _isLoading = true;
    notifyListeners();

    try {
      _historicalData = await _apiService.fetchHistoricalData(symbol);
    } catch (e) {
      _historicalData = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
