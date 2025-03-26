import 'package:get/get.dart';
import 'package:msf/features/doc/doc.dart';
import 'package:msf/features/home_screen.dart';
import 'package:msf/features/interface/add_interface_screen.dart';
import 'package:msf/features/interface/manage_interface_screen.dart';
import 'package:msf/features/login/otpscreen.dart';
import 'package:msf/features/login/login_screen.dart';
import 'package:msf/features/setting_screen.dart';
import 'package:msf/features/statistic_screen.dart';
import 'package:msf/features/system/active_connections_screen.dart';
import 'package:msf/features/system/general_configuration_screen.dart';
import 'package:msf/features/system/media_screen.dart';
import 'package:msf/features/system/routes_screen.dart';
import 'package:msf/features/system/users/add_user_screen.dart';
import 'package:msf/features/system/users/user_managment_screen.dart';
import 'package:msf/features/system_log/internal_errorlog_screen.dart';
import 'package:msf/features/system_log/waf_log_screen.dart';
import 'package:msf/features/system_log/user_actionlog_screen.dart';
import 'package:msf/features/waf/waf_rule_screen.dart';
import 'package:msf/features/websites/add_website_screen.dart';
import 'package:msf/features/websites/edit_webite.dart';
import 'package:msf/features/websites/website_log.dart';
import 'package:msf/features/websites/websites_screen.dart';

import '../../features/system_log/ngnix_log_screen.dart';
import '../../features/waf/waf__manage_screen.dart';

class AppRouter {
  static String loginRoute = "/login";
  static String homeRoute = "/home";
  static String staticsRoute = "/statics";
  static String websiteRoute = "/websites";
  static String addWebsiteRoute = '/add_websites';
  static String websiteLogRoute = '/log_websites';
  static String editWebsiteRoute = '/edit_websites';
  static String wafRuleScreen = '/waf_rule';
  static String wafManagerScreen = '/waf_manager';
  static String manageWafRoute = '/manage_Waf';
  static String systemRoute = '/system_routes';
  static String activeConnectionRoute = '/active_connection';
  static String generalConfigurationRoute = '/general_confg';
  static String userManagmentRoute = '/user_management';
  static String addUserManagmentRoute = '/add_management';
  static String addVirtualipRoute = '/add_virtualip';
  static String manageVirtualipRoute = '/manage_virtualip';
  static String WafLogRoute = '/Waf_log';
  static String NginxLogRoute = '/nginx_log';
  static String userActionLogRoute = '/user_actionlog';
  static String internalErrorLogRoute = '/internal_errorlog';
  static String mediaRoute = '/media';
  static String settingRoute = '/setting';
  static String otpRoute = '/otp';
  static String docRoute = '/doc';
  static final appPages = [
    GetPage(name: staticsRoute, page:()=> StatisticScreen()),
    GetPage(name: loginRoute, page: () => LoginScreen()),
    GetPage(name: wafRuleScreen, page: () => WafRuleScreen()),
    GetPage(name: wafManagerScreen, page: () => WafManagerScreen()),
    GetPage(name: homeRoute, page: () => HomeScreen()),
    GetPage(name: websiteRoute, page: () => const WebsitesScreen()),
    GetPage(name: addWebsiteRoute, page: () =>  AddWebsiteScreen()),
    GetPage(name: websiteLogRoute, page: () => const WebsitesLogScreen()),
    GetPage(name: editWebsiteRoute, page: () => const EditWebsite()),
    GetPage(
      name: activeConnectionRoute,
      page: () => const ActiveConnectionsScreen(),
    ),
    GetPage(
      name: generalConfigurationRoute,
      page: () => const GeneralConfigurationScreen(),
    ),
    GetPage(name: userManagmentRoute, page: () => const UserManagementScreen()),
    GetPage(name: mediaRoute, page: () => const MediaScreen()),
    GetPage(name: addUserManagmentRoute, page: () => const AddUserScreen()),
    GetPage(name: addVirtualipRoute, page: () => const AddInterfaceScreen()),
    GetPage(name: manageVirtualipRoute, page: () => const ManageInterfaceScreen()),
    GetPage(name: systemRoute, page: () => const RoutesScreen()),
    GetPage(name: WafLogRoute, page: () =>  WafLogScreen()),
    GetPage(name: NginxLogRoute, page: () =>  NginxLogScreen()),
    GetPage(name: userActionLogRoute, page: () =>  UserActionLogScreen()),
    GetPage(
        name: internalErrorLogRoute,
        page: () =>  InternalErrorLogScreen()),
    GetPage(name: settingRoute, page: () => Settingscreen()),
    GetPage(name: otpRoute, page: () => OtpScreen()),
    GetPage(name: docRoute, page: () => DocScreen()),
  ];
}
