import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockChart extends StatelessWidget {
  final List<Map<String, dynamic>> stockHistory;

  StockChart({required this.stockHistory});

  @override
  Widget build(BuildContext context) {
    // Reverse the stockHistory list
    final reversedStockHistory = stockHistory.reversed.toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (reversedStockHistory.length / 5).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final int index = value.toInt();
                if (index >= 0 && index < reversedStockHistory.length) {
                  return Text(reversedStockHistory[index]['date']);
                } else {
                  return Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: reversedStockHistory
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value['close']))
                .toList(),
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final index = touchedSpot.x.toInt();
                final date = reversedStockHistory[index]['date'];
                final close = reversedStockHistory[index]['close'];
                return LineTooltipItem(
                  '$date\nClose: $close',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}
