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
        //centerSpaceColor: const Color(0xFF040404),
        sectionsSpace: 0,  // Remove space between sections
        centerSpaceRadius: 35,  // Reduce center space
        pieTouchData: PieTouchData(enabled: true),
        sections: [
          PieChartSectionData(
            radius: 5,
            value: value1,
            color: const Color(0xFFff9585),
            title: 'impact.com',  // Display percentage
          ),
          PieChartSectionData(
            radius: 5,
            value: value2,
            color: Color(0xFFC0C0C0),
            title: 'eBay',
          ),
        ],
      ),
    );
  }
}
