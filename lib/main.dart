import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:synergy_app/pages/login_or_direct.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class FetchingApi {
  Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse(
        'https://api.thingspeak.com/channels/2456315/feeds.json?results=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final latestFeed = responseData['feeds']?.last;

        if (latestFeed != null) {
          return {
            'voltage': double.parse(latestFeed['field1'] ?? '0'),
            'current': double.parse(latestFeed['field2'] ?? '0'),
            'energy': double.parse(latestFeed['field3'] ?? '0'),
            'power': double.parse(latestFeed['field4'] ?? '0'),
            'frequency': double.parse(latestFeed['field5'] ?? '0'),
          };
        }
        return {};
      } else {
        print('Failed to load data: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching data: $e');
      return {};
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: LoginOrDirect(), // Wraps the LoginOrDirect widget
    );
  }
}
