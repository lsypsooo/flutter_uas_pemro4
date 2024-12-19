import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/game/game.dart';
import 'package:flutter_uas/admin/model/tags_model.dart';
import 'package:flutter_uas/api_service/api.dart';
import 'package:image_picker/image_picker.dart';


import 'package:toastification/toastification.dart';

class UpdateGamePage extends StatefulWidget {
  const UpdateGamePage({super.key});
  static String routeName = '/update-Game';
  @override
  State<UpdateGamePage> createState() => _UpdateGamePageState();
}

class _UpdateGamePageState extends State<UpdateGamePage> {
  final dio = Dio();
  bool isLoading = false;
  int? idtags;
  String? tags;
  int? idGame;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TagsModel? _selectedtags;

  Future<List<TagsModel>> getData() async {
    try {
      var response = await Dio().get(getAllTags);
      final data = response.data["data"];
      if (data != null) {
        return TagsModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      // Pick an image
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
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    titleController.text = args['title'];
    priceController.text = args['price'].toString();
    ratingController.text = args['rating'].toString();
    descriptionController.text = args['description'];
    idGame = args['id_game'];
    tags = args['tags_game_tagsTotags']['name'].toString();
    idtags = args['tags_game_tagsTotags']['id_tags'];

    return Scaffold(
      backgroundColor: const Color(0xFF232429),
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text("Form Edit Game",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Rating",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
                    hintText: "Search tags...",
                  ),
                ),
              ),
              asyncItems: (String? filter) => getData(),
              itemAsString: (TagsModel? item) => item?.userAsString() ?? "",
              onChanged: (TagsModel? data) {
                setState(() {
                  _selectedtags = data;
                  idtags = data?.id_tags;
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select tags",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              selectedItem: _selectedtags,
              dropdownBuilder:
                  (BuildContext context, TagsModel? selectedItem) {
                var text = _selectedtags == null
                    ? tags.toString()
                    : _selectedtags!.name;
                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white, // Warna teks yang dipilih
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
              child: const Text("Pilih Gambar",
                  style: TextStyle(color: Colors.white)),
            ),
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
                : Image.network("$imageUrl/${args['image']}",
                    width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(
              height: 32,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      updateGameResponse(_imageBytes, titleController.text, priceController.text, _selectedtags == null ? idtags : _selectedtags!.id_tags, ratingController.text, descriptionController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Edit Game",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ))),
    );
  }

  void updateGameResponse(image, title, price, tags, rating, description) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));

      var data = <String, dynamic>{
        if (image != null)
          "image": MultipartFile.fromBytes(
            image!,
            filename: 'test.jpg',
          ),
        "title": title, // Menghapus spasi berlebih
        "price": price.toString(),
        "tags": tags.toString(),
        "rating": rating.toString(),
        "description": description,
      };

      FormData formData = FormData.fromMap(data);
      Response response;

      response = await dio.put(editGame+idGame.toString(), data: formData);
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, GamePage.routeName);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi kesalaha pada server"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}