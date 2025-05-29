import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';

class DeveloperThoughtsScreen extends StatelessWidget {
  const DeveloperThoughtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Get.find<TranslateController>().isEnglish.value ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: isRtl,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: isRtl == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                "Developer Final Thoughts".tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Support".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "For issues, contact your system administrator or support team. Provide log details and error messages for faster resolution.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}