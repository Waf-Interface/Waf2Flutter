import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/dashboard/component/view_linechart.dart';
import 'package:msf/core/utills/_colorconfig.dart';

class Viewers extends StatelessWidget {
   Viewers({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isCinematic = themeController.isCinematic.value;

  return Container(
      width: double.infinity,
      height: 410,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCinematic ? ColorConfig.glassColor : secondryColor  ,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Viewers'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: ViewLineChart(),
          )
        ],
      ),
    );
  }
}
