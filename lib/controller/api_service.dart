import 'dart:convert';
import 'package:http/http.dart' as http;
import '../stock_model.dart';

class ApiService {
  final String apiKey = 'MNLEZYX2W5AKKI2F';

  Future<List<Stock>> searchStocks(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body)['bestMatches'];
      return results.map((json) => Stock.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search stocks');
    }
  }

  Future<List<HistoricalData>> fetchHistoricalData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body)['Time Series (Daily)'];
      return json.entries.map((entry) => HistoricalData.fromJson(entry)).toList();
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}



class HistoricalData {
  final String date;
  final double close;

  HistoricalData({required this.date, required this.close});

  factory HistoricalData.fromJson(MapEntry<String, dynamic> entry) {
    return HistoricalData(
      date: entry.key,
      close: double.parse(entry.value['4. close']),
    );
  }
}
