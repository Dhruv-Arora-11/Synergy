import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synergy_app/main.dart';
import 'package:synergy_app/pages/HomePage.dart';
import 'package:synergy_app/pages/SecondPage.dart';

class LoginOrDirect extends StatelessWidget {
  var datas;
  LoginOrDirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<Map<String, dynamic>>(
              future: FetchingApi().fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.white, // Set your desired background color
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final datas = snapshot.data;
                return SecondPage(datas: datas); // Pass resolved data
              },
            );
          } else {
            return HomePage(datas: datas);
          }
        },
      ),
    );
  }
}
