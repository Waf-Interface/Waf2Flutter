import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';

class ApiReferenceScreen extends StatelessWidget {
  const ApiReferenceScreen({super.key});

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
                "API Reference".tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "This section provides guidance on using the WAF Manager’s backend APIs for advanced integrations.".tr,
                style: Theme.of(context).textTheme.bodyLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Overview".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "The WAF Manager interacts with a backend server to perform actions like fetching logs, updating configurations, and managing rules. APIs are used for:\n- Retrieving audit and debug logs.\n- Managing ModSecurity rules.\n- Deploying websites.\n- Updating Nginx and ModSecurity configurations.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "How to Use APIs".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "1. Obtain an API token from your administrator.\n2. Use a tool like Postman or cURL to send requests.\n3. Include the token in the Authorization header.\n4. Refer to the endpoint documentation (contact your administrator for details).\nNote: API endpoints are not publicly exposed in this guide. Request access for specific documentation.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Example Actions".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "- Fetch Logs: Retrieve logs for a website.\n- Update Rule: Modify a ModSecurity rule.\n- Deploy Website: Deploy a pending website to the server.\nContact support for endpoint URLs and parameters.".tr,
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