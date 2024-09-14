import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final double value1;
  final double value2;

  CustomBarChart({required this.value1, required this.value2});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        //backgroundColor: const Color(0xFF040404),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(show: false),  // Hide axis titles
        gridData: FlGridData(show: false),  // Hide background grids
        borderData: FlBorderData(show: false),  // Remove border
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: value1, width: 10, color: Colors.red),  // First bar
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: value2, width: 10, color: const Color(0xFFC9C8CA)),  // Second bar
          ]),
        ],
      ),
    );
  }
}
