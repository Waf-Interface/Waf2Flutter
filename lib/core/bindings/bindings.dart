import 'package:get/get.dart';
import 'package:msf/features/controllers/Interface/InterfaceController.dart';
import 'package:msf/features/controllers/auth/CaptchaController.dart';
import 'package:msf/features/controllers/dashboard/CounterController.dart';
import 'package:msf/features/controllers/auth/LoginController.dart';
import 'package:msf/features/controllers/log/LogContorller.dart';
import 'package:msf/features/controllers/log/NginxLogController.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';
import 'package:msf/features/controllers/settings/IdleController.dart';
import 'package:msf/features/controllers/dashboard/ResourceUsageController.dart';
import 'package:msf/features/controllers/system/SystemController.dart';
import 'package:msf/features/controllers/update/UpdateController.dart';
import 'package:msf/features/controllers/waf/WafController.dart';
import 'package:msf/features/controllers/waf/WafRule.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';
import 'package:msf/features/controllers/websites/uploads/UploadController.dart';
import 'package:msf/features/controllers/websites/website/websiteController.dart';
import '../../features/controllers/user/UserController.dart';
import '../../features/controllers/ws/WsController.dart';

class MyBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(WebsiteController());
    Get.put(UploadController());
    Get.put(UpdateController());
    Get.put(SystemController());
    Get.put(UserController());
    Get.put(NginxLogController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => InterfaceController());
    Get.lazyPut(() => Menu_Controller());
    Get.lazyPut(() => WafRuleController());
    Get.put(Counter());
    Get.put(WafLogController());
    Get.put(WafSetupController());
    Get.put(LogController());
    Get.lazyPut(() => TranslateController());
    Get.put(IdleController());
    Get.lazyPut(() => ResourceUsageController());
    Get.put(WsController());
    Get.lazyPut(() => CaptchaController());
  }
}
