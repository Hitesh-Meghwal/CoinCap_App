import 'dart:convert';
import 'dart:js_interop';

import 'package:coincap_app/Models/app_config.dart';
import 'package:coincap_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();  //ensureing widgets binding proper
  await loadConfig();
  runApp(const MyApp());
}

Future<void> loadConfig() async{
  String _configContent = await rootBundle.loadString('assets/config/main.json');
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"])
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Cap App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage()
    );
  }
}
