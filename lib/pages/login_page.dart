import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controller/login_controller.dart';
import '../helpers/custome_color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    controller.passwordController.clear();
    controller.usernameController.clear();

    return Scaffold(
      backgroundColor: CustomColors().extraColor,
      body: Form(
        key: controller.loginkey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [CustomColors().primaryColor, CustomColors().extraColor2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Buktor Grow',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 5.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: controller.usernameController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: GoogleFonts.aBeeZee(),
                                hintText: 'Enter your email',
                                hintStyle: GoogleFonts.aBeeZee(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorStyle:
                                    GoogleFonts.aBeeZee(color: Colors.red),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email can't be empty";
                                }
                                return null;
                              },
                              style: GoogleFonts.aBeeZee(),
                            ),
                            const SizedBox(height: 16.0),
                            Obx(() => TextFormField(
                                  controller: controller.passwordController,
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: GoogleFonts.aBeeZee(),
                                    hintText: 'Enter your password',
                                    hintStyle: GoogleFonts.aBeeZee(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorStyle:
                                        GoogleFonts.aBeeZee(color: Colors.red),
                                    suffixIcon: IconButton(
                                      icon: HugeIcon(
                                        color: Colors.black,
                                        icon: controller.isPasswordVisible.value
                                            ? HugeIcons.strokeRoundedView
                                            : HugeIcons
                                                .strokeRoundedViewOffSlash,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password can't be empty";
                                    }
                                    return null;
                                  },
                                  style: GoogleFonts.aBeeZee(),
                                )),
                            const SizedBox(height: 30.0),
                            SizedBox(
                              height: 50,
                              width: Get.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  controller.login();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: CustomColors().primaryColor,
                                ),
                                child: Obx(
                                  () => controller.isLoading.value
                                      ? SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            color: CustomColors().tertiaryColor,
                                          ),
                                        )
                                      : Text(
                                          'Sign in',
                                          style: GoogleFonts.aBeeZee(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.03),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Need Help?",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8, right: 8),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //           height: 1.0,
                            //           color: Colors.grey.shade600,
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 8.0),
                            //         child: Text(
                            //           style: GoogleFonts.aBeeZee(),
                            //           'Or',
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: Container(
                            //           height: 1.0,
                            //           color: Colors.grey.shade600,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: Get.height * 0.03),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey.shade50,
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all(
                            //       color: Colors.blueGrey.shade50,
                            //     ),
                            //   ),
                            //   height: 40,
                            //   width: Get.width,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Container(
                            //         height: 20,
                            //         width: 20,
                            //         decoration: BoxDecoration(
                            //             shape: BoxShape.circle,
                            //             color: Colors.blue.shade900),
                            //         child: Center(
                            //             child: Text("f",
                            //                 style: GoogleFonts.aBeeZee(
                            //                     fontSize: 20,
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.bold))),
                            //       ),
                            //       const SizedBox(width: 10),
                            //       Text(
                            //         style: GoogleFonts.aBeeZee(),
                            //         'Sign In with Facebook',
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(height: 25.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
