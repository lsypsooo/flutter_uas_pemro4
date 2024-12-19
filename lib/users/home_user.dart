import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/api_service/api.dart';
import 'package:flutter_uas/auth/login_page.dart';
import 'package:flutter_uas/users/beli_game.dart';
import 'package:flutter_uas/users/transaksi_user.dart';

import 'package:toastification/toastification.dart';

class HomeUsers extends StatefulWidget {
  const HomeUsers({super.key});
  static const routeName = '/home_users';

  @override
  State<HomeUsers> createState() => _HomeUsersState();
}

class _HomeUsersState extends State<HomeUsers> {
  bool isLoading = false;
  var dataGame = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 58, 127, 183),
          title: Row(
            children: [
              const Text('GameVault', style: TextStyle(color: Colors.white))
            ],
          ),
          actions: [
            Row(children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, TransaksiUser.routeName,arguments: args);
                },
                icon: const Icon(
                  Icons.shopping_basket_sharp,
                  color: Colors.white,
                )),IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ))
            ],)
          ],
        ),
        backgroundColor: Color.fromARGB(255, 204, 221, 244),
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
                                  "Tags: ${Game['tags_game_tagsTotags']['name']}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Rp. ${Game['price']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 10),
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
                                      'Beli',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, BeliGame.routeName,
                                              arguments: {
                                                "game": Game,
                                                "user": args
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.shopping_basket_rounded,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(width: 10),
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
}
