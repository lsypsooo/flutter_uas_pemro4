import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uas/api_service/api.dart';
import 'package:flutter_uas/users/home_user.dart';

import 'package:toastification/toastification.dart';
class TransaksiUser extends StatefulWidget {
  const TransaksiUser({super.key});
  static String routeName = '/transaksi-user';
  @override
  State<TransaksiUser> createState() => _TransaksiUserState();
}
class _TransaksiUserState extends State<TransaksiUser> {
  final dio = Dio();
  bool isLoading = false;
  bool isLoadingDelete = false;
  var dataTransaksiUser = [];
  String? idUser;
  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    idUser = args['username'];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 58, 127, 183),
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeUsers.routeName,
                      arguments: args);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Text('Transaksi', style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        backgroundColor: const Color(0xFF232429),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: dataTransaksiUser.length,
                itemBuilder: (context, index) {
                  var transaksiUser = dataTransaksiUser[index];
                  var status =
                      transaksiUser['status']; // Ambil status dari data
                  return Card(
                    color: Colors.grey[900], // Warna latar belakang card
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(15), // Padding di dalam card
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ikon di sebelah kiri
                          const Icon(
                            Icons.games,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(
                              width: 15), // Spasi antara ikon dan teks
                          // Informasi transaksi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaksiUser['game']['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                height: 8,
                              ),
                               Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: status == 1
                                      ? Colors.red
                                      : Colors.green, // Warna badge
                                  borderRadius:
                                      BorderRadius.circular(20), // Badge bulat
                                ),
                                child: Text(
                                  status == 1 ? "Belum Lunas" : "Lunas",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                                Text(
                                  "Total: Rp. ${transaksiUser['total']}",
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
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
      response = await dio.get(getTransaksiByUser + idUser.toString());
      if (response.data['status'] == true) {
        dataTransaksiUser = response.data['data'];
      } else {
        dataTransaksiUser = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server tidak meresponse'),
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