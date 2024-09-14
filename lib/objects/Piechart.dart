import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final double value1;
  final double value2;

  CustomPieChart({required this.value1, required this.value2});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceColor: const Color(0xFF040404),
        sectionsSpace: 0,  // Remove space between sections
        centerSpaceRadius: 10,  // Reduce center space
        pieTouchData: PieTouchData(enabled: true),
        sections: [
          PieChartSectionData(
            value: value1,
            color: Colors.red,
            title: 'impact.com',  // Display percentage
          ),
          PieChartSectionData(
            value: value2,
            color: const Color(0xFFC9C8CA),
            title: 'eBay',
          ),
        ],
      ),
    );
  }
}
