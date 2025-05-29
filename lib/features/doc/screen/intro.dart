import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  // تابع کمکی برای تشخیص اینکه متن فارسی است یا نه
  bool _isPersian(String text) {
    final persianRegex = RegExp(r'[\u0600-\u06FF]');
    return persianRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.find<TranslateController>().isEnglish.value;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Directionality(
              textDirection: _isPersian("Welcome to WAF Manager".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "Welcome to WAF Manager".tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: _isPersian("Welcome to WAF Manager".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: _isPersian("The WAF Manager is a powerful tool...".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "The WAF Manager is a powerful tool for managing Web Application Firewalls (WAFs), monitoring website security, and configuring server settings. This section introduces its key features and how to get started.".tr,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: _isPersian("The WAF Manager is a powerful tool...".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: _isPersian("Key Features".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "Key Features".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: _isPersian("Key Features".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: _isPersian("- Website Management...".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "- Website Management: Add, edit, deploy, and monitor websites.\n- WAF Configuration: Manage ModSecurity rules and exclusions.\n- Log Statistics: View audit and debug logs with summaries.\n- Responsive Interface: Works on mobile, tablet, and desktop.\n- Customization: Toggle dark mode, cinematic mode, and languages (English/Persian).".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: _isPersian("- Website Management...".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: _isPersian("How to Use".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "How to Use".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: _isPersian("How to Use".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: _isPersian("1. Navigate using the sidebar...".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "1. Navigate using the sidebar (visible on desktop or via the menu icon on mobile).\n2. Start by adding a website in the Setup section.\n3. Use the Control Panel to manage WAF settings and view logs.\n4. Refer to the API Reference for advanced integrations.\n5. Check Developer Final Thoughts for tips and best practices.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: _isPersian("1. Navigate using the sidebar...".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: _isPersian("Next Steps".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "Next Steps".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: _isPersian("Next Steps".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: _isPersian("Go to the Setup section...".tr) ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                "Go to the Setup section to add your first website or explore the Control Panel to manage existing ones.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: _isPersian("Go to the Setup section...".tr) ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}