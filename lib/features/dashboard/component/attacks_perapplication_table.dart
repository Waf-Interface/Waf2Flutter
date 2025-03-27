import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/log/NginxLogController.dart';

class QuickSummary extends StatelessWidget {
  const QuickSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final NginxLogController controller = Get.find<NginxLogController>();
    const Color secondaryColor = Color(0xFF2A2D3E);
    final String today = DateTime.now().toIso8601String().split('T')[0]; // "2025-03-26"

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: double.infinity,
        height: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quick Summary".tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSummaryItem(
                            context,
                            "Total Requests",
                            Obx(() => Text(
                              controller.logSummary['total_requests']?.toString() ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )),
                          ),
                          _buildSummaryItem(
                            context,
                            "Unique IPs",
                            Obx(() => Text(
                              controller.logSummary['unique_ips']?.toString() ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )),
                          ),
                          _buildSummaryItem(
                            context,
                            "Today's Traffic",
                            Obx(() => Text(
                              controller.dailyTraffic[today]?.toString() ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )),
                          ),
                          _buildSummaryItem(
                            context,
                            "Most Requests Day",
                            Obx(() {
                              String mostRequestsDay = 'N/A';
                              int mostRequestsCount = 0;
                              if (controller.dailyTraffic.isNotEmpty) {
                                final traffic = controller.dailyTraffic;
                                mostRequestsDay = traffic.entries.reduce((a, b) => a.value > b.value ? a : b).key;
                                mostRequestsCount = traffic[mostRequestsDay] ?? 0;
                              }
                              return Text(
                                "$mostRequestsDay ($mostRequestsCount)",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatusItem(
                                    context,
                                    "200",
                                    Obx(() => Text(
                                      (controller.logSummary['status_counts'] as Map<String, dynamic>?)?['200']
                                          ?.toString() ??
                                          '0',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )),
                                  ),
                                  _buildStatusItem(
                                    context,
                                    "404",
                                    Obx(() => Text(
                                      (controller.logSummary['status_counts'] as Map<String, dynamic>?)?['404']
                                          ?.toString() ??
                                          '0',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )),
                                  ),
                                  _buildStatusItem(
                                    context,
                                    "301",
                                    Obx(() => Text(
                                      (controller.logSummary['status_counts'] as Map<String, dynamic>?)?['301']
                                          ?.toString() ??
                                          '0',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )),
                                  ),
                                  _buildStatusItem(
                                    context,
                                    "403",
                                    Obx(() => Text(
                                      (controller.logSummary['status_counts'] as Map<String, dynamic>?)?['403']
                                          ?.toString() ??
                                          '0',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, String status, Widget countWidget) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          status,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        countWidget,
      ],
    );
  }
}