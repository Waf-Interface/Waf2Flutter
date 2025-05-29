import 'dart:math'; // برای انتخاب تصادفی کلمات
import 'dart:ui'; // برای BackdropFilter
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/AnimatedWidgets/hypterAnim/strategies/FadeBlurStrategy.dart';
import 'package:msf/features/controllers/auth/CaptchaController.dart';
import 'package:msf/features/controllers/auth/LoginController.dart';
import 'package:msf/core/utills/_colorconfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/core/utills/AnimatedWidgets/typingAnim/typing_anim.dart';
import 'package:msf/core/utills/AnimatedWidgets/hypterAnim/text_reveal_widget.dart';
import 'package:msf/core/utills/AnimatedWidgets/smokeAnim/smoke.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaInputController = TextEditingController();
  final CaptchaController captchaController = Get.find<CaptchaController>();

  final List<String> randomWords = [
    'Secure',
    'Fast',
    'Modern',
    'Reliable',
    'Innovative'
  ];

  String currentWord = 'Secure';

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          currentWord = randomWords[Random().nextInt(randomWords.length)];
        });
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDarkMode
        ? Colors.white.withOpacity(0.09)
        : Colors.white.withOpacity(0.3);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          // افکت SmokeAnim در پس‌زمینه
          const SmokeHomeWidget(),
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: Responsive.isDesktop(context)
                            ? screenHeight * 0.8
                            : screenHeight * 0.96,
                        margin: Responsive.isDesktop(context)
                            ? const EdgeInsets.fromLTRB(200, 0, 200, 0)
                            : const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: glassColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.01)
                                : Colors.black.withOpacity(0.0),
                          ),
                        ),
                        child: Padding(
                          padding: Responsive.isDesktop(context)
                              ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
                              : const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome to Waf Interface!",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 30,
                                          child: EnhancedTextRevealEffect(
                                            key: ValueKey(
                                                currentWord),
                                            text: currentWord,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: textColor.withOpacity(0.8),
                                            ),
                                            duration:
                                                const Duration(seconds: 1),
                                            strategy: FadeBlurStrategy(),
                                            unit: AnimationUnit.character,
                                            trigger: true,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? screenWidth * 0.4
                                              : screenWidth * 0.8,
                                          height: 60,
                                          child: TextField(
                                            controller: usernameController,
                                            decoration: InputDecoration(
                                              hintText: "Username",
                                              fillColor:
                                                  secondryColor.withOpacity(
                                                      isDarkMode ? 0.2 : 0.5),
                                              filled: true,
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? screenWidth * 0.4
                                              : screenWidth * 0.8,
                                          height: 60,
                                          child: TextField(
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              hintText: "Password",
                                              fillColor:
                                                  secondryColor.withOpacity(
                                                      isDarkMode ? 0.2 : 0.5),
                                              filled: true,
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Obx(() => Text(
                                              captchaController.captcha.value,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: textColor,
                                              ),
                                            )),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? screenWidth * 0.4
                                              : screenWidth * 0.8,
                                          height: 60,
                                          child: TextField(
                                            controller: captchaInputController,
                                            decoration: InputDecoration(
                                              hintText: "Enter Captcha",
                                              fillColor:
                                                  secondryColor.withOpacity(
                                                      isDarkMode ? 0.2 : 0.5),
                                              filled: true,
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              captchaController
                                                  .verifyCaptcha(value);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Obx(
                                          () => Get.find<LoginController>()
                                                  .loginProcess
                                                  .value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primaryColor
                                                            .withOpacity(0.4),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    minimumSize: Size(
                                                      Responsive.isDesktop(
                                                              context)
                                                          ? screenWidth * 0.2
                                                          : screenWidth * 0.8,
                                                      50,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (!Get.find<
                                                            LoginController>()
                                                        .loginProcess
                                                        .value) {
                                                      if (captchaController
                                                          .isCaptchaCorrect
                                                          .value) {
                                                        Get.find<
                                                                LoginController>()
                                                            .login(
                                                          usernameController
                                                              .text,
                                                          passwordController
                                                              .text,
                                                        );
                                                      } else {
                                                        Get.snackbar("Error",
                                                            "Captcha is incorrect!");
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Ver: Beta 0.1.9.9",
                    style: TextStyle(color: textColor),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
