// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:travel_management/store/auth_store.dart';
// import 'package:travel_management/views/home.dart';
// import 'package:travel_management/views/onboarding.dart';

// class EntryPoint extends StatelessWidget {
//   final store = GetStorage();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: ,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasData && snapshot.data == true) {
//           return Home();
//         } else {
//           return Onboarding();
//         }
//       },
//     );
//   }
// }
