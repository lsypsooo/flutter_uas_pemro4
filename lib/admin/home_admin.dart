import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/game/game.dart';
import 'package:flutter_uas/admin/tags/tags.dart';
import 'package:flutter_uas/admin/transaksi/transaksi.dart';
import 'package:flutter_uas/auth/login_page.dart';


class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});
  static const routeName = '/home_admin';

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Icon(Icons.home, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                "GameVault",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          )),
      body: Container(
        color: const Color(0xFF232429),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF472d7b),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        // onTap: () =>
                        //     Navigator.pushNamed(context, Page1.routes),
                        onTap: () =>
                            Navigator.pushNamed(context, Tags.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.games,
                                size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Tags',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 110,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF472d7b),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, GamePage.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.videogame_asset, size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Game', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF472d7b),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, TransaksiAdmin.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.receipt,
                                size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Transaction',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 110,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2f2f2f),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, LoginPage.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.logout, size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Logout',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
