import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'stock_provider.dart'; // Import provider and ApiService

class StockChartScreen extends StatelessWidget {
  final String symbol;

  StockChartScreen({required this.symbol});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context, listen: false);

    // Fetch historical data for the given symbol when this screen is loaded
    provider.fetchHistoricalData(symbol);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 14, 33),
        title: Text(
          'Stock Chart: $symbol',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back button color to white
        ),
      ),
      backgroundColor: Color.fromARGB(255, 10, 13, 33),
      body: Consumer<StockProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.historicalData.isEmpty) {
            return Center(child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ));
          } else {
            // Reverse the historical data
            final reversedData = provider.historicalData.reversed.toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < reversedData.length) {
                            return Text(reversedData[index].date, style: TextStyle(color: Colors.white));
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: reversedData
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.close))
                          .toList(),
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      tooltipMargin: 16,// Set the tooltip background color here
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final date = reversedData[spot.x.toInt()].date;
                          final price = spot.y;
                          return LineTooltipItem(
                            '$date\nPrice: \$${price.toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
