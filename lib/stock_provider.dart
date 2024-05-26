import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the ApiService
import 'stock_model.dart'; // Import the Stock and HistoricalData models

class StockProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Stock> _stocks = [];
  List<HistoricalData> _historicalData = [];
  bool _isLoading = false;

  List<Stock> get stocks => _stocks;
  List<HistoricalData> get historicalData => _historicalData;
  bool get isLoading => _isLoading;

  Future<void> searchStocks(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _stocks = await _apiService.searchStocks(query);
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
