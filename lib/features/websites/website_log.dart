import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/status_widget.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/waf/WafWebsite.dart';
import 'package:msf/features/websites/components/log_chart.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final WafWebsiteController wafController;
  final String websiteId = Get.arguments ?? '';
  final RxList<Map<String, dynamic>> auditLogs = <Map<String, dynamic>>[].obs;
  int criticalCount = 0;
  int warningCount = 0;
  int noticeCount = 0;
  int totalRequests = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    wafController = Get.put(WafWebsiteController());
    _fetchAuditLogs();

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAuditLogs() async {
    if (websiteId.isNotEmpty) {
      try {
        final logString = await wafController.getAuditLog(websiteId);
        print('Audit Log Raw: $logString');
        final logs = _parseAuditLog(logString);
        auditLogs.assignAll(logs);
        _updateSummaryCounts(logs);
      } catch (e) {
        print('Error fetching audit logs: $e');
        Get.snackbar(
          "Error",
          "Failed to fetch audit logs: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "No website ID provided",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  List<Map<String, dynamic>> _parseAuditLog(String logString) {
    final lines = logString.split('\n').where((line) => line.trim().isNotEmpty).toList();
    return List.generate(lines.length, (index) {
      final parts = lines[index].split(' ').where((part) => part.isNotEmpty).toList();
      return {
        '#': index + 1,
        'timestamp': parts.isNotEmpty ? parts[0] : 'N/A',
        'level': parts.length > 1 ? parts[1] : 'N/A',
        'message': parts.length > 2 ? parts.sublist(2).join(' ') : 'No Message',
      };
    });
  }

  void _updateSummaryCounts(List<Map<String, dynamic>> logs) {
    criticalCount = logs.where((log) => log['level'].toString().toLowerCase() == 'critical').length;
    warningCount = logs.where((log) => log['level'].toString().toLowerCase() == 'warning').length;
    noticeCount = logs.where((log) => log['level'].toString().toLowerCase() == 'notice').length;
    totalRequests = logs.length;
  }

  void _showLogDetails(BuildContext context, Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text("Audit Log Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("ID: ${log['#']}"),
                Text("Timestamp: ${log['timestamp'] ?? 'N/A'}"),
                Text("Level: ${log['level'] ?? 'N/A'}"),
                Text("Message: ${log['message'] ?? 'N/A'}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: isCinematic
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.all(16),
                decoration: isCinematic
                    ? BoxDecoration(
                  color: ColorConfig.glassColor,
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
                  ),
                  borderRadius: BorderRadius.circular(10),
                )
                    : BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CustomIconbuttonWidget(
                      backColor: Colors.transparent,
                      onPressed: () => Get.back(),
                      icon: Icons.arrow_back,
                    ),
                    const SizedBox(width: 5),
                    Text(websiteId.isNotEmpty ? "Audit Logs for $websiteId" : "Audit Logs"),
                  ],
                ),
              ),
            ),
          );
        }),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: isCinematic
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: isCinematic
                    ? BoxDecoration(
                  color: ColorConfig.glassColor,
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
                  ),
                  borderRadius: BorderRadius.circular(10),
                )
                    : BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      indicator: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: ColorConfig.primaryColor,
                          ),
                        ),
                      ),
                      labelColor: Colors.white,
                      tabs: const [
                        Tab(text: "Summary"),
                        Tab(text: "Audit Logs"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: _tabController.index == 0 ? _summaryTab() : _auditLogsTab(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _summaryTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Attack Summary"),
          const SizedBox(
            height: 350,
            width: double.infinity,
            child: LogChart(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: StatusWidget(
                  title: "Critical: $criticalCount",
                  backgrounColor: Colors.red[900],
                  titleColor: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: StatusWidget(
                  title: "Warning: $warningCount",
                  backgrounColor: Colors.yellow[700],
                  titleColor: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: StatusWidget(
                  title: "Notice: $noticeCount",
                  backgrounColor: Colors.green[700],
                  titleColor: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: StatusWidget(
                  title: "Error: 0",
                  backgrounColor: Colors.red[100],
                  titleColor: Colors.red[800],
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: StatusWidget(
                  title: "Total Requests: $totalRequests",
                  backgrounColor: Colors.white38,
                  titleColor: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _auditLogsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text("Showing last ${auditLogs.length} audit logs")),
              CustomIconbuttonWidget(
                backColor: ColorConfig.primaryColor,
                title: "Reload",
                icon: Icons.refresh,
                titleColor: Colors.white,
                iconColor: Colors.white,
                onPressed: _fetchAuditLogs,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (wafController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (auditLogs.isEmpty) {
              return const Center(
                child: Text(
                  "No audit logs available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("#")),
                    DataColumn(label: Text("Timestamp")),
                    DataColumn(label: Text("Level")),
                    DataColumn(label: Text("Message")),
                  ],
                  rows: auditLogs.map((log) {
                    return DataRow(
                      onSelectChanged: (selected) {
                        if (selected ?? false) {
                          _showLogDetails(context, log);
                        }
                      },
                      cells: [
                        DataCell(Text(log['#'].toString())),
                        DataCell(Text(log['timestamp'] ?? 'N/A')),
                        DataCell(Text(log['level'] ?? 'N/A')),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              log['message'] ?? 'No Message',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}