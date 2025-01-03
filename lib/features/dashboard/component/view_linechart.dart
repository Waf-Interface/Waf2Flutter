import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/utills/colorconfig.dart';
import 'package:get/get.dart';

class ViewLineChart extends StatefulWidget {
  const ViewLineChart({super.key});

  @override
  _ViewLineChartState createState() => _ViewLineChartState();
}

class _ViewLineChartState extends State<ViewLineChart> {
  List<Color> gradientColors = [
    primaryColor,
    secondryColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Sun'.tr,
                          style: const TextStyle(color: Colors.white));
                    case 4:
                      return Text('Mon'.tr,
                          style: const TextStyle(color: Colors.white));
                    case 7:
                      return Text('Tue'.tr,
                          style: const TextStyle(color: Colors.white));
                    case 10:
                      return Text('Wed'.tr,
                          style: const TextStyle(color: Colors.white));
                    case 13:
                      return Text('Thu'.tr,
                          style: const TextStyle(color: Colors.white));
                    case 16:
                      return Text('Fri'.tr,
                          style: const TextStyle(color: Colors.white));
                    case 19:
                      return Text('Sat'.tr,
                          style: const TextStyle(color: Colors.white));
                  }
                  return Container();
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 20,
          minY: 0,
          maxY: 6,
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(4, 2),
                const FlSpot(9, 4),
                const FlSpot(12, 3),
                const FlSpot(15, 5),
                const FlSpot(18, 3),
                const FlSpot(20, 4),
              ],
              isCurved: true,
              color: primaryColor,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors:
                      gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
