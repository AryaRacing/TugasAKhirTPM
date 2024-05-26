class Stock {
  final String symbol;
  final String name;

  Stock({required this.symbol, required this.name});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['1. symbol'],
      name: json['2. name'],
    );
  }
}
