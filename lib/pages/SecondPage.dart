import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synergy_app/pages/HomePage.dart';
import 'CurrentDisplayPage.dart';
import 'EnergyDisplayPage.dart';
import 'FrequencyDisplayPage.dart';
import 'PowerDisplayPage.dart';
import 'VoltageDisplayPage.dart';

class SecondPage extends StatelessWidget {
  final Map<String, dynamic>? datas;

  SecondPage({super.key, required this.datas});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              child: const Icon(Icons.login),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(datas: datas),
                    ));
              },
            ),
          )
        ],
        title: const Text('Previous Readings',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(4, 8),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(
                            '${datas?["current"] ?? "No current data"}',
                            "current"),
                        _buildInfoColumn(
                            '${datas?["voltage"] ?? "No current data"}',
                            "voltage"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(
                            '${datas?["frequency"] ?? "No current data"}',
                            "Frequency"),
                        _buildInfoColumn(
                            '${datas?["power"] ?? "No current data"}', "Power"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${datas?["energy"] ?? "No data for Energy"}',
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Energy',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Services',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildServiceButton(context, 'Current', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrentDisplayPage(
                          datas: datas,
                        ),
                      ),
                    );
                  }),
                  _buildServiceButton(context, 'Voltage', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoltageDisplayPage(
                          datas: datas,
                        ),
                      ),
                    );
                  }),
                  _buildServiceButton(context, 'Frequency', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FrequencyDisplayPage(
                          datas: datas,
                        ),
                      ),
                    );
                  }),
                  _buildServiceButton(context, 'Power', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PowerDisplayPage(
                          datas: datas,
                        ),
                      ),
                    );
                  }),
                  _buildServiceButton(context, 'Energy', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnergyDisplayPage(
                          datas: datas,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom function to build the info columns with corporate font and layout
  Widget _buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 28,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Custom function to build service buttons with subtle shadow and modern design
  Widget _buildServiceButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.lightBlueAccent, // Refined color for a professional touch
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2, // Increased elevation for a more noticeable shadow
        shadowColor: Colors.black
            .withOpacity(0.1), // Darker shadow color for stronger effect
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
