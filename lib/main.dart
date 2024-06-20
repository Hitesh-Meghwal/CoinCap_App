import 'dart:convert';

import 'package:coincap_app/Models/app_config.dart';
import 'package:coincap_app/Services/http_services.dart';
import 'package:coincap_app/Views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensuring widgets binding properly
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp() async {
  await loadConfig();
}

Future<void> loadConfig() async {
  try {
    String _configContent = await rootBundle.loadString('assets/config/main.json');
    Map _configData = jsonDecode(_configContent);

    if (_configData.containsKey("COIN_API_BASE_URL") && _configData["COIN_API_BASE_URL"] != null) {
      GetIt.instance.registerSingleton<AppConfig>(
        AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"])
      );
      registerHTTPService(); // Register HTTPService after AppConfig is registered
    } else {
      throw Exception('COIN_API_BASE_URL not found or is null');
    }
  } catch (e) {
    print('Error loading config: $e');
  }
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService()
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
