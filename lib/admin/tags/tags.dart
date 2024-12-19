import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/home_admin.dart';
import 'package:flutter_uas/admin/tags/input_tags.dart';
import 'package:flutter_uas/admin/tags/update_tags.dart';
import 'package:flutter_uas/api_service/api.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';

class Tags extends StatefulWidget {
  const Tags({super.key});
  static String routeName = "/Tags";
  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final dio = Dio();
  bool isLoading = false;
  bool isLoadingDelete = false;
  var dataTags = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
                    Navigator.pushNamed(context, HomeAdmin.routeName);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white)),
              const Text('Tags', style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, InputTags.routeName);
                },
                icon: const Icon(Icons.add, color: Colors.white))
          ]),
      backgroundColor: const Color(0xff232429),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                var Tags = dataTags[index];
                return ListTile(
                  title: Text(
                    Tags['name'],
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.gamepad,
                    color: Colors.white,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, UpdateTags.routeName,
                                arguments: Tags);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.yellowAccent,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () async {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: 'Hapus Tags',
                                text:
                                    'Yakin ingin menghapus Tags ${Tags['name']} ?',
                                confirmBtnText: isLoadingDelete
                                    ? 'Mengapus Data.....'
                                    : 'Ya',
                                cancelBtnText: 'Tidak',
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () {
                                  deleteTagsResponse(Tags['id_tags']);
                                });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ))
                    ],
                  ),
                );
              },
              itemCount: dataTags.length,
            ),
    );
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      Response response;
      response = await dio.get(getAllTags);
      if (response.data['status'] == true) {
        dataTags = response.data['data'];
      } else {
        dataTags = [];
      }
      ;
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text('Server tidak merespon'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 2),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteTagsResponse(int id) async {
    try {
      setState(() {
        isLoading = true;
      });
      Response response;
      response = await dio.delete(hapusTags + id.toString());
      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['message']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, Tags.routeName);
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Terjadi kesalahan pada server'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
