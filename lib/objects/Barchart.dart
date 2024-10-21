import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> xLabels;
  CustomBarChart({required this.data, required this.xLabels});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        //backgroundColor: const Color(0xFF040404),
        // Customize left titles (y-axis)

               
              gridData: const FlGridData(show: true, drawVerticalLine: false,),


                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Map the integer x value to a string label
                        switch (value.toInt()) {
                          case 0:
                            return Text('>= \$${xLabels[0]}', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold));
                          case 1:
                            return Text("> \$${xLabels[1]}", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold));
                          case 2:
                            return Text("> \$${xLabels[2]}", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold));
                          case 3:
                            return Text("> \$${xLabels[3]}", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold));
                          case 4:
                            return Text(">= \$${xLabels[4]}", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold));
                          
                          default:
                            return Text('');
                        }
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
    
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text('${value.toInt()}'); // Show counts
                      },
                      //reservedSize: 40, // To make space for the label
                    ),
                    //axisNameSize: 15,
                    axisNameWidget: 
                     const Text(
                        'Number of Offers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    
                  ),
                ),
        barTouchData: BarTouchData(enabled: true),  // Hide background grids
        borderData: FlBorderData(show: false),  // Remove border
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: data[0], width: 20, color: Colors.red),  // First bar
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: data[1], width: 20, color: Color(0xFFC0C0C0)),  // Second bar
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: data[2], width: 20, color: Colors.red),  // Second bar
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: data[3], width: 20, color: Color(0xFFC0C0C0)),  // Second bar
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(toY: data[4], width: 20, color: Colors.red),  // Second bar
          ]),
          
          
        ],
      ),
    );
  }
}
