import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/tags/tags.dart';
import 'package:flutter_uas/api_service/api.dart';

import 'package:toastification/toastification.dart';

class UpdateTags extends StatefulWidget {
  const UpdateTags({super.key});
  static String routeName = "/update_Tags";
  @override
  State<UpdateTags> createState() => _UpdateTagsState();
}

class _UpdateTagsState extends State<UpdateTags> {
  final dio = Dio();
  bool isLoading = false;
  TextEditingController TagsController = TextEditingController();
  String nama = "";
  int? id_Tags;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    nama = args['name'];
    id_Tags = args['id_tags'];
    TagsController.text = nama;
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
                const Text('Edit Tags',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: TagsController,
                  decoration: const InputDecoration(
                    labelText: "Nama Tags",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                  style: TextStyle(color: Colors.white) ,
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
                          if (TagsController.text.isEmpty &&
                              TagsController.text == '') {
                            toastification.show(
                                context: context,
                                title:
                                    const Text("Username tidak boleh kosong!"),
                                type: ToastificationType.error,
                                autoCloseDuration: const Duration(seconds: 3),
                                style: ToastificationStyle.fillColored);
                          } else {
                            updateTagsResponse(
                                id_Tags!, TagsController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text(
                          "Edit",
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

  void updateTagsResponse(int id_tags, name) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      Response response;
      response =
          await dio.put(editTags + id_tags.toString(), data: {"name": name});
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
