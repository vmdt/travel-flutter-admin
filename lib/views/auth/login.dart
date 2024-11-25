import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_management/common/app_style.dart';
import 'package:travel_management/common/reusable_text.dart';
import 'package:travel_management/constants/constants.dart';
import 'package:travel_management/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final authController = Get.put(AuthController()); // Khởi tạo AuthController

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReusableText(
                text: 'Welcome to Travel Admin',
                style: appStyle(20.sp, dark, FontWeight.w600),
              ),
              SizedBox(height: 40.h),

              // Email TextField
              TextField(
                controller: emailController, // Gắn controller
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: Icon(Icons.email, size: 20.sp),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),

              // Password TextField
              TextField(
                controller: passwordController, // Gắn controller
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: Icon(Icons.lock, size: 20.sp),
                ),
                obscureText: true,
              ),
              SizedBox(height: 10.h),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Xử lý quên mật khẩu
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 14.sp, color: black),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Nút đăng nhập
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      Get.snackbar(
                          "Error", "Email and password cannot be empty.",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    try {
                      await authController.login(email, password);

                      Get.snackbar(
                        "Success",
                        "Login successful!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color.fromARGB(255, 84, 192, 88),
                        colorText: Colors.white,
                      );
                      // Get.offAllNamed(
                      //     '/home'); // Chuyển hướng sau khi đăng nhập
                      // Get.offAllNamed('/discount_management');
                      Get.offNamed('/discount-management');
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor:
                            const Color.fromARGB(255, 235, 100, 90),
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreen,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
