import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/game/game.dart';
import 'package:flutter_uas/admin/model/tags_model.dart';
import 'package:flutter_uas/api_service/api.dart';
import 'package:image_picker/image_picker.dart';

import 'package:toastification/toastification.dart';
import 'package:dropdown_search/dropdown_search.dart';

class InputGame extends StatefulWidget {
  const InputGame({super.key});
  static const routeName = '/input_Game';

  @override
  State<InputGame> createState() => _InputGameState();
}

class _InputGameState extends State<InputGame> {
  final dio = Dio();
  bool isLoading = false;

  int? id_tags;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TagsModel? _selectedTags;

  Future<List<TagsModel>> getData() async {
    try {
      var response = await Dio().get(getAllTags);
      final data = response.data["data"];
      if (data != null) {
        return TagsModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('terjadi keasalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      throw Exception("Failed to pick image: $e");
    }
  }

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
                height: 100,
              ),
              const Text(
                "Form Input Game",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(
                  labelText: "Rating",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownSearch<TagsModel>(
                popupProps: PopupProps.dialog(
                  itemBuilder:
                      (BuildContext context, TagsModel item, bool isDisabled) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        title: Text(item.name),
                        leading: CircleAvatar(child: Text(item.name[0])),
                      ),
                    );
                  },
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search Tags...",
                    ),
                  ),
                ),
                asyncItems: (String? filter) => getData(),
                itemAsString: (TagsModel? item) => item?.userAsString() ?? "",
                onChanged: (TagsModel? data) {
                  setState(() {
                    _selectedTags = data;
                    id_tags = data?.id_tags;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Tags",
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                selectedItem: _selectedTags,
                dropdownBuilder:
                    (BuildContext context, TagsModel? selectedItem) {
                  return Text(
                    selectedItem?.name ?? "Select Tags",
                    style: const TextStyle(
                      color: Colors.black, // Warna teks yang dipilih
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50)),
                  child: const Text(
                    "Pilih Gambar",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 16,
              ),
              _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : const Text(
                      'Tidak ada gambar yang dipilih',
                      style: TextStyle(color: Colors.black),
                    ),
              const SizedBox(
                height: 16,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        inputGameResponse();
                        // if (Tagscontroller.text.isEmpty && Tagscontroller.text == '') {
                        //   toastification.show(
                        //       context: context,
                        //       title: const Text("Username Tidak Boleh Kosong!"),
                        //       type: ToastificationType.error,
                        //       autoCloseDuration: const Duration(seconds: 3),
                        //       style: ToastificationStyle.fillColored);
                        // } else {
                        //   inputResponse();
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Input Game",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void inputGameResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      print(id_tags);
      print(priceController.text);

      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(_imageBytes!, filename: 'test.jpg'),
        "title": titleController.text,
        "price": priceController.text,
        "tags": id_tags,
        "rating": ratingController.text,
        "description": descriptionController.text
      });
      Response response;
      response = await dio.post(inputGame, data: formData);
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, GamePage.routeName);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("terjadi kesalahan pada server"),
          type: ToastificationType.error,
          autoCloseDuration: Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
