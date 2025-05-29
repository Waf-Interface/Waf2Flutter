import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

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
                "Setup Guide".tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "This section explains how to add and deploy websites in the WAF Manager application.".tr,
                style: Theme.of(context).textTheme.bodyLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Adding a New Website".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "1. Navigate to the Add Website section via the sidebar.\n2. In the Add New Application panel:\n   - Enter an Application Name (e.g., 'MyWebsite', no spaces).\n   - Enter the Application URL (e.g., 'www.mywebsite.com').\n3. Click 'Save' to add the website to the pending list.\n4. A confirmation message will appear if successful.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Managing Pending Websites".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "Pending websites appear in the Applications Pending to Preview table. For each website, you can:\n- Upload: If the status is 'Waiting for zip', click the upload icon to provide a zip file.\n- Deploy: If the status is 'Ready to deploy!', click the cloud upload icon to deploy to the server.\n- Delete: Click the delete icon to remove the website from the list.\nNote: Ensure the status is correct before performing actions. Errors will display as snackbar messages.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Tips".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "- Verify the URL format before saving.\n- Upload valid zip files to avoid deployment errors.\n- Check the Control Panel to manage deployed websites.".tr,
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