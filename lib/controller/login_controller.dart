import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_client_f/model/user/user.dart';
import 'package:ecom_client_f/pages/home_page.dart';
import 'package:ecom_client_f/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'dart:math';

class LoginController extends GetxController {
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();
  TextEditingController loginNumberCtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEntered;

  User? loginUser ;

  @override
  void onReady () {
    Map<String, dynamic> ? user = box.read('loginUser');
    if(user != null) {
      loginUser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('user');
    super.onInit();
  }

  void addUser() {
    try {
      if (otpSend == otpEntered) {
        DocumentReference doc = userCollection.doc();
        final userJson = {
          'id': doc.id,
          'name': registerNameCtrl.text,
          'number': int.parse(registerNumberCtrl.text)
        };
        doc.set(userJson);
        Get.snackbar('Success', 'User added successfully',colorText: Colors.green);
        registerNumberCtrl.clear();
        registerNameCtrl.clear();
        otpController.clear();

      } else {
        Get.snackbar('Error', 'Enter Correct OTP', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  Future<void> sendOtp() async { // Changed from outside to inside the class
    try {
      if (registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Please fill the required field',
            colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      String mobileNumber = registerNumberCtrl.text; // Added semicolon
      String url = 'https://www.fast2sms.com/dev/bulkV2?authorization=15ElXxqUcnwgjRV3aIMvZNPpW8yAhm2zK0fGDiJbtLsd69OQuFlj6Tt3XerW95ZMxfUmBOCnKV8AGuc4&route=otp&variables_values=$otp&flash=0&numbers=$mobileNumber';
      Response response = await GetConnect().get(url);
      print(otp);
      if (response.body ['message'] [0]== 'SMS sent successfully.') {
        otpFieldShown = true;
        otpSend = otp;
        Get.snackbar('Success', 'OTP sent successfully',
            colorText: Colors.green);
        update(); // Ensure state update
      } else {
        Get.snackbar('Error', 'OTP not sent', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithPhone() async {
    try {
      String phoneNumber = loginNumberCtrl.text;
      if (phoneNumber.isNotEmpty) {
        var querySnapshot = await userCollection.where('number', isEqualTo: int.tryParse(phoneNumber)).limit(1).get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('loginUser', userData);
          loginNumberCtrl.clear();
          Get.to(const HomePage());
          Get.snackbar('Success', 'Login Successfull!',colorText: Colors.green);
        } else {
          Get.snackbar('Error', 'User not found! Please Register',colorText: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Please Enter Phone Number',colorText: Colors.red);
      }
    } catch(e) {
      print(e);
    }
  }
}
