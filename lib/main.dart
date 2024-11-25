import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travel_management/views/auth/login.dart';
import 'package:travel_management/views/discount/discount.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetStorage storage = GetStorage();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Travel Management',
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                primarySwatch: Colors.grey),
            getPages: [
              GetPage(name: '/login', page: () => LoginScreen()),
              GetPage(
                  name: '/discount-management',
                  page: () => DiscountManagementScreen()),
            ],
            home: LoginScreen());
      },
    );
  }
}
