import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class GeneralConfigurationScreen extends StatefulWidget {
  const GeneralConfigurationScreen({super.key});

  @override
  State<GeneralConfigurationScreen> createState() =>
      _GeneralConfigurationScreenState();
}

class _GeneralConfigurationScreenState
    extends State<GeneralConfigurationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final ThemeController themeController = Get.find<ThemeController>();
  final isDarkMode = Get.theme.brightness == Brightness.dark;

  TextEditingController usernameTextcontroller = TextEditingController();
  TextEditingController passwordTextcontroller = TextEditingController();
  TextEditingController senderTextcontroller = TextEditingController();
  TextEditingController hostTextcontroller = TextEditingController();
  TextEditingController portTextcontroller = TextEditingController();
  TextEditingController captchaPubTextcontroller = TextEditingController();
  TextEditingController captchaPrivateTextcontroller = TextEditingController();
  TextEditingController emailTextcontroller = TextEditingController();

  bool enableRecaptcha2 = false;
  bool enable2factor = false;

  @override
  void dispose() {
    usernameTextcontroller.dispose();
    passwordTextcontroller.dispose();
    senderTextcontroller.dispose();
    hostTextcontroller.dispose();
    portTextcontroller.dispose();
    captchaPubTextcontroller.dispose();
    captchaPrivateTextcontroller.dispose();
    emailTextcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      sectionWidgets: [
        Responsive(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              configurationSection,
              const SizedBox(width: 10, height: 10),
              routesSection,
            ],
          ),
          tablet: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: configurationSection),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 2, child: routesSection),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: configurationSection),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 2, child: routesSection),
            ],
          ),
        ),
      ],
    );
  }

  Widget get configurationSection {
    return Obx(() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("img/gear.png", width: 60),
                    SizedBox(width: 10),
                    const AutoSizeText(
                      "General Configuration",
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const AutoSizeText(
                  "SMTP Username",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: usernameTextcontroller,
                  hintText: "user@mail.com",
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "SMTP Password",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: passwordTextcontroller,
                  hintText: "****",
                  inputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "SMTP Sendor",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: senderTextcontroller,
                  hintText: "some_mail@gmail.com",
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "SMTP Host",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: hostTextcontroller,
                  hintText: "smtp@gmail.com",
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "SMTP Port",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: senderTextcontroller,
                  hintText: "587",
                  maxLength: 5,
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "Enable Google Recaptch2 ?:",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                CustomDropdownWidget(
                  list: ["Disable", "Enable"],
                  value: enableRecaptcha2 ? "Enable" : "Disable",
                  onchangeValue: (value) {},
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "Captcha public key",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: captchaPubTextcontroller,
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "Captcha private key",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: captchaPrivateTextcontroller,
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  "Enable 2 factor Authentication ?:",
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                CustomDropdownWidget(
                  list: ["Disable", "Enable"],
                  value: enable2factor ? "Enable" : "Disable",
                  onchangeValue: (value) {},
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: CustomIconbuttonWidget(
                    backColor: ColorConfig.primaryColor,
                    onPressed: () {},
                    title: "Submit",
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget get routesSection => Obx(() {
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
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("img/warning.png", width: 50),
                      SizedBox(width: 10),
                      const AutoSizeText(
                        "Attention",
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•'),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.justify,
                              'When you enable Recaptcha, first be sure the public and private key are working. DON\'T LOGOUT, open another browser or private mode and try to log in to see if captcha correctly set up. Be sure your domain or IP is in the whitelist domain for Google Recaptcha.',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•'),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.justify,
                              'Please test the SMTP configuration before enabling 2-Factor Authentication.',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(color: Colors.black12),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 180,
                    child: CustomIconbuttonWidget(
                      backColor: Colors.transparent,
                      onPressed: () {},
                      title: " Test SMTP Configuration",
                      icon: Icons.mail_outline_outlined,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Email:"),
                  SizedBox(height: 10),
                  DashboardTextfield(
                    textEditingController: emailTextcontroller,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 80,
                    child: CustomIconbuttonWidget(
                      backColor: ColorConfig.primaryColor,
                      onPressed: () {},
                      title: "Submit",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  });
}