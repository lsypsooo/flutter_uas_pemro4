import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/game/input_game.dart';
import 'package:flutter_uas/admin/game/update_game.dart';
import 'package:flutter_uas/admin/home_admin.dart';
import 'package:flutter_uas/api_service/api.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  static String routeName = '/Game-admin';

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  bool isLoading = false;
  bool isLoadingDelete = false;
  var dataGame = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeAdmin.routeName);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text('Game', style: TextStyle(color: Colors.white))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, InputGame.routeName);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: Color(0xFF232429),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: dataGame.length,
                itemBuilder: (context, index) {
                  final Game = dataGame[index];
                  return Card(
                    color: Colors.grey[850],
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Film
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl + Game['image'],
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey,
                                  child:
                                      const Icon(Icons.broken_image, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Detail Film
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Judul Film
                                Text(
                                  Game['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Genre
                                Text(
                                  "Genre: ${Game['tags_game_tagsTotags']['name']}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Rating dengan Bintang
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      Icons.star,
                                      size: 16,
                                      color: starIndex < Game['rating'].toInt()
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  )..add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          Game['rating'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                                const SizedBox(height: 10),
                                // Deskripsi Film
                                Text(
                                  Game['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              UpdateGamePage.routeName,
                                              arguments: Game);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.yellow,
                                        )),
                                    const SizedBox(width: 10),
                                    const Text('Hapus',
                                        style: TextStyle(color: Colors.white)),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.confirm,
                                              title: 'Hapus Game',
                                              text:
                                                  'Yakin ingin menghapus Game ${Game['title']} ?',
                                              confirmBtnText: isLoadingDelete
                                                  ? 'Mengapus Data.....'
                                                  : 'Ya',
                                              cancelBtnText: 'Tidak',
                                              confirmBtnColor: Colors.red,
                                              onConfirmBtnTap: () {
                                                deleteGameResponse(
                                                    Game['id_game']);
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getAllGame);
      if (response.data['status'] == true) {
        dataGame = response.data['data'];
        print(dataGame);
      } else {
        dataGame = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server Tidak Merespone'),
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

  void deleteGameResponse(int id) async {
    try {
      setState(() {
        isLoading = true;
      });
      Response response;
      response = await dio.delete(hapusGame + id.toString());
      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, GamePage.routeName);
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
