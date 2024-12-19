import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/tags/tags.dart';
import 'package:flutter_uas/api_service/api.dart';

import 'package:toastification/toastification.dart';

class InputTags extends StatefulWidget {
  const InputTags({super.key});
  static String routeName = "/input_Tags";
  @override
  State<InputTags> createState() => _InputTagsState();
}

class _InputTagsState extends State<InputTags> {
  final dio = Dio();
  bool isLoading = false;
  TextEditingController namaTagsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Tags.routeName);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white)),
              const Text('Input Tags', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        backgroundColor: const Color(0xff232429),
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
                const SizedBox(
                  height: 16.0,
                ),
                const Text('Input Tags Baru',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: namaTagsController,
                  decoration: const InputDecoration(
                      labelText: "Nama Tags",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (namaTagsController.text.isEmpty &&
                              namaTagsController.text == '') {
                            toastification.show(
                                context: context,
                                title:
                                    const Text("Username tidak boleh kosong!"),
                                type: ToastificationType.error,
                                autoCloseDuration: const Duration(seconds: 3),
                                style: ToastificationStyle.fillColored);
                          } else {
                            tambahkanResponse();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text(
                          "Tambahkan",
                          style: TextStyle(color: Colors.white),
                        )),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        )));
  }

  void tambahkanResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      Response response;
      response =
          await dio.post(insertTags, data: {"name": namaTagsController.text});
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['message']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, Tags.routeName);
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['message']),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
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
