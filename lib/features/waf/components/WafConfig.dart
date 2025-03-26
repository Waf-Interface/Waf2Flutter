import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';
import 'package:msf/features/waf/components/EditConfigScreen.dart';

class WafConfigWidget extends StatelessWidget {
  final WafSetupController controller = Get.find<WafSetupController>();

   WafConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    HttpService httpService = HttpService();
    controller.setHttpService(httpService);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Configuration Files",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(
                          screenWidth < 600 ? 100 : 120, // Smaller on mobile, larger on tablet/desktop
                          36,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () {
                        Get.to(() => EditConfigScreen(fileKey: "modsecurity"));
                      },
                      child: const Text(
                        "ModSecurity",
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(
                          screenWidth < 600 ? 100 : 120,
                          36,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () {
                        Get.to(() => EditConfigScreen(fileKey: "crs_setup"));
                      },
                      child: const Text(
                        "CRS Setup",
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(
                          screenWidth < 600 ? 100 : 120,
                          36,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () {
                        Get.to(() => EditConfigScreen(fileKey: "nginx"));
                      },
                      child: const Text(
                        "Nginx",
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}