import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msf/core/utills/_colorconfig.dart';
import 'package:msf/features/controllers/log/NginxLogController.dart';
import 'dart:math' as math;

class ViewLineChart extends StatelessWidget {
  final List<Color> gradientColors = [primaryColor, secondryColor];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NginxLogController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(child: CircularProgressIndicator()),
        );
      } else if (controller.dailyTraffic.isEmpty) {
        return  Center(child: Text('No data'.tr));
      } else {
        var trafficData = controller.dailyTraffic.value;
        var dates = trafficData.keys.toList()..sort();
        var spots = List.generate(dates.length, (i) => FlSpot(i.toDouble(), trafficData[dates[i]].toDouble()));
        var maxTraffic = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
        var maxY = math.max(1, (maxTraffic * 1.1).ceil()).toDouble();

        var numLabels = dates.length <= 7 ? dates.length : 7;
        var step = numLabels > 1 ? (dates.length - 1) / (numLabels - 1) : 0;
        var indicesToShow = List.generate(numLabels, (i) => (i * step).round()).toSet();

        var firstDate = DateTime.parse(dates.first);
        var lastDate = DateTime.parse(dates.last);
        var daysSpan = lastDate.difference(firstDate).inDays + 1;

        double rangeMaxX;
        if (dates.length < 14) {
          rangeMaxX = math.min(13, dates.length - 1); //  2 weeks
        } else if (dates.length < 30) {
          rangeMaxX = math.min(29, dates.length - 1); //  1 month
        } else if (dates.length < 44) {
          rangeMaxX = math.min(43, dates.length - 1); //  6 weeks
        } else if (dates.length < 60) {
          rangeMaxX = math.min(59, dates.length - 1); //  2 months
        } else {
          rangeMaxX = dates.length - 1; // Full range
        }

        return LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    var index = value.toInt();
                    if (index >= 0 && index < dates.length && indicesToShow.contains(index)) {
                      var date = DateTime.parse(dates[index]);
                      return Text(
                        DateFormat('dd MMM').format(date),
                        style: const TextStyle(color: Colors.white),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: rangeMaxX,
            minY: 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: primaryColor,
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}