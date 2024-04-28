import 'package:ecom_client_f/controller/login_controller.dart';
import 'package:ecom_client_f/pages/login_pages.dart';
import 'package:ecom_client_f/widgets/otp_txt_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(
        builder: (ctrl) {
          return Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create your account!!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: ctrl.registerNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Your Name',
                    hintText: "Enter your name",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: ctrl.registerNumberCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: 'Mobile Number',
                    hintText: "Enter your mobile number",
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: ctrl.otpFieldShown,
                  child: OtpTextField(
                    otpController: ctrl.otpController,
                    isVisible: ctrl.otpFieldShown,
                    onCompleted: (otp) {
                      ctrl.otpEntered = int.tryParse(otp ?? '0000');
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (ctrl.otpFieldShown) {
                      ctrl.addUser();
                    } else {
                      ctrl.sendOtp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(
                    ctrl.otpFieldShown ? 'Register' : 'Send OTP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  child: const Text('Login'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
