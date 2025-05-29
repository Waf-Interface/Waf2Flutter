import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/utills/_colorconfig.dart';

class LogChart extends StatefulWidget {
  const LogChart({super.key});

  @override
  LogChartState createState() => LogChartState();
}

class LogChartState extends State<LogChart> {
  List<Color> gradientColors = [
    primaryColor,
    secondryColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ScatterChart(
        ScatterChartData(
          // Grid Lines
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: 0.2,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
          ),
          // Axis Titles
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final labels = [
                    "Critical",
                    "Warning",
                    "Notice",
                    "Error",
                    "Requests"
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      value.toInt() < labels.length
                          ? labels[value.toInt()]
                          : "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 0.2,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          // Scatter Points
          scatterSpots: [
            ScatterSpot(0, 0.5,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(1, -0.4,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(2, -0.6,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(3, 0.8,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(4, -0.2,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(2, -0.9,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(1, 0.3,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(4, -0.7,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(3, -0.5,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
            ScatterSpot(0, -0.8,
                dotPainter: FlDotCrossPainter(color: Colors.blue)),
          ],
          // Chart Borders
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          // Chart Range
          minX: 0,
          maxX: 5,
          minY: -1,
          maxY: 1,
          scatterTouchData: ScatterTouchData(
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipItems: (ScatterSpot touchedSpot) {
                return ScatterTooltipItem(
                  '(${touchedSpot.x}, ${touchedSpot.y})',
                  textStyle: const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
