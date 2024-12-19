import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/api_service/api.dart';
import 'package:flutter_uas/users/home_user.dart';

import 'package:toastification/toastification.dart';

class BeliGame extends StatefulWidget {
  const BeliGame({super.key});
  static String routeName = '/beli-Game';
  @override
  State<BeliGame> createState() => _BeliGameState();
}

class _BeliGameState extends State<BeliGame> {
  final dio = Dio();
  bool isLoading = false;
  var total = 0.0;
  String? userId;
  int? GameId;
  var user;

  TextEditingController titleController = TextEditingController();
  TextEditingController jumlahBeliController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    titleController.text = args['game']['title'];
    totalController.text = args['game']['price'].toString();
    GameId = args['game']['id_game'];
    userId = args['user']['username'];
    user = args['user'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Beli Game",),
        backgroundColor: const Color.fromARGB(255, 58, 127, 183),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    "$imageUrl/${args['game']['image']}",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  style: TextStyle(color: Colors.black),
                  enabled: false,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey.withOpacity(0.05),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: totalController,
                   style: TextStyle(color: Colors.black),
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Price",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey.withOpacity(0.05),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: totalController,
                  style: TextStyle(color: Colors.black),
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Total",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey.withOpacity(0.05),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 58, 127, 183),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          responseTransaksi();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 58, 127, 183),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Beli Game",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void responseTransaksi() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      Response response;
      response = await dio.post(insertTransaksi, data: {
        "username": userId,
        "id_game": GameId,
        "total": totalController.text,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3));
        Navigator.pushNamed(context, HomeUsers.routeName, arguments: user);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: Text('Terjadi kesalahan pada server'),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
