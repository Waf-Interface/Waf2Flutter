import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/auth/LoginController.dart';
import 'package:msf/core/utills/_colorconfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/core/utills/AnimatedWidgets/smokeAnim/smoke.dart';

class OtpScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final LoginController loginController = Get.find<LoginController>();

  OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDarkMode
        ? Colors.white.withOpacity(0.09)
        : Colors.white.withOpacity(0.3);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          const SmokeHomeWidget(),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? screenWidth * 0.6
                      : screenWidth * 0.95,
                  height: Responsive.isDesktop(context)
                      ? screenHeight * 0.8
                      : screenHeight * 0.96,
                  margin: Responsive.isDesktop(context)
                      ? const EdgeInsets.fromLTRB(200, 0, 200, 0)
                      : const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.01)
                          : Colors.black.withOpacity(0.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enter OTP",
                        style: TextStyle(fontSize: 30, color: textColor),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Please enter the OTP sent to your device".tr,
                        style: TextStyle(fontSize: 18, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: "OTP",
                            fillColor: secondryColor
                                .withOpacity(isDarkMode ? 0.2 : 0.5),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                            Responsive.isDesktop(context)
                                ? screenWidth * 0.3
                                : screenWidth * 0.8,
                            50,
                          ),
                        ),
                        onPressed: () async {
                          int otp = int.tryParse(otpController.text) ?? 0;
                          if (otp > 0) {
                            await loginController.verifyOtp(otp);
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please enter a valid OTP",
                              icon: const Icon(Icons.error, color: Colors.red),
                              backgroundColor: Colors.white,
                              maxWidth: 360,
                              isDismissible: true,
                            );
                          }
                        },
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}