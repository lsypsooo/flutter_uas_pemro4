import 'package:flutter/material.dart';
import 'package:flutter_uas/admin/game/game.dart';
import 'package:flutter_uas/admin/game/input_game.dart';
import 'package:flutter_uas/admin/game/update_game.dart';
import 'package:flutter_uas/admin/home_admin.dart';
import 'package:flutter_uas/admin/tags/input_tags.dart';
import 'package:flutter_uas/admin/tags/tags.dart';
import 'package:flutter_uas/admin/tags/update_tags.dart';
import 'package:flutter_uas/admin/transaksi/transaksi.dart';
import 'package:flutter_uas/auth/login_page.dart';
import 'package:flutter_uas/auth/register_page.dart';
import 'package:flutter_uas/users/beli_game.dart';
import 'package:flutter_uas/users/home_user.dart';
import 'package:flutter_uas/users/transaksi_user.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GameVault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomeAdmin.routeName: (context) => const HomeAdmin(),
        HomeUsers.routeName: (context) => const HomeUsers(),
        Tags.routeName: (context) => const Tags(),
        GamePage.routeName: (context) => const GamePage(),
        InputTags.routeName: (context) => const InputTags(),
        UpdateTags.routeName: (context) => const UpdateTags(),
        InputGame.routeName: (context) => const InputGame(),
        UpdateGamePage.routeName: (context) => const UpdateGamePage(),
        BeliGame.routeName: (context) => const BeliGame(),
        TransaksiAdmin.routeName: (context) => const TransaksiAdmin(),
        TransaksiUser.routeName: (context) => const TransaksiUser(),
       
      },
    );
  }
}
