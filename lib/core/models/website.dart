import 'package:get/get.dart';

class Website {
  String name;
  String url;
  String author;
  RxString status; // For API-fetched status
  String? addWebsiteStatus; // For AddWebsiteScreen status
  bool initStatus;
  String zipPath;
  String? id;
  String? listenTo;
  String? realWebServer;
  String? mode;
  String? modsecAuditLog;
  List<dynamic>? customRules;
  String? timestamp;
  bool? wafEnabled;
  String? modsecDebugLog;
  List<dynamic>? ruleBackups;

  Website({
    required this.name,
    required this.url,
    required this.author,
    required this.status,
    this.addWebsiteStatus,
    required this.initStatus,
    required this.zipPath,
    this.id,
    this.listenTo,
    this.realWebServer,
    this.mode,
    this.modsecAuditLog,
    this.customRules,
    this.timestamp,
    this.wafEnabled,
    this.modsecDebugLog,
    this.ruleBackups,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      name: json['name'] ?? '',
      url: json['application'] ?? '',
      author: "admin",
      status: (json['status'] as String? ?? '').obs,
      initStatus: json['init_status'] ?? false,
      zipPath: "",
      id: json['id'],
      listenTo: json['listen_to'],
      realWebServer: json['real_web_s'],
      mode: json['mode'],
      modsecAuditLog: json['modsec_audit_log'],
      customRules: json['custom_rules'],
      timestamp: json['timestamp'],
      wafEnabled: json['waf_enabled'],
      modsecDebugLog: json['modsec_debug_log'],
      ruleBackups: json['rule_backups'],
    );
  }
}