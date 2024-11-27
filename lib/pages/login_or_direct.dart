import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synergy_app/main.dart';
import 'package:synergy_app/pages/HomePage.dart';
import 'package:synergy_app/pages/SecondPage.dart';

class LoginOrDirect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return FutureBuilder<Map<String, dynamic>>(
              future: FetchingApi().fetchData(),
              builder: (context, fetchSnapshot) {
                if (fetchSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (fetchSnapshot.hasError) {
                  return Center(child: Text('Error: ${fetchSnapshot.error}'));
                }
                final datas = fetchSnapshot.data;
                return SecondPage(datas: datas); // Pass fetched data
              },
            );
          } else {
            return FutureBuilder<Map<String, dynamic>>(
              future: FetchingApi().fetchData(),
              builder: (context, fetchSnapshot) {
                if (fetchSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (fetchSnapshot.hasError) {
                  return Center(child: Text('Error: ${fetchSnapshot.error}'));
                }
                final datas = fetchSnapshot.data;
                return HomePage(datas: datas); // Pass resolved data
              },
            );
          }
        },
      ),
    );
  }
}