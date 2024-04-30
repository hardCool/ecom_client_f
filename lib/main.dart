import 'package:ecom_client_f/controller/home_controller.dart';
import 'package:ecom_client_f/controller/login_controller.dart';
import 'package:ecom_client_f/controller/purchase_controller.dart';
import 'package:ecom_client_f/pages/login_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchaseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Corrected use of colorScheme
        // useMaterial3: true, // Removed useMaterial3
      ),
      home: LoginPage(), // Corrected LoginPage import
    );
  }
}
