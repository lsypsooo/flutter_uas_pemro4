import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/api_service/api.dart';
import 'package:flutter_uas/auth/login_page.dart';

import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String routeName = "/register-page";
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Register account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: "Fullname",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            const SizedBox(
              height: 16,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text("Username tidak boleh kosong!"),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else if (fullNameController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text("fullname tidak boleh kosong!"),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else if (emailController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text("Email tidak boleh kosong!"),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else if (phoneController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text("Phone tidak boleh kosong!"),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else if (passwordController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text("Password tidak boleh kosong!"),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else {
                        registerResponse();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    )),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                    child: Text('Login'))
              ],
            )
          ],
        ),
      ),
    )));
  }

  void registerResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(register, data: {
        "username": usernameController.text,
        "fullname": fullNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, LoginPage.routeName);
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      print(e);
      toastification.show(
          context: context,
          title: const Text("Terjadi Kesalahan Pada Server"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
