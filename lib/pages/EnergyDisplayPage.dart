import 'package:flutter/material.dart';
import 'package:synergy_app/main.dart';

class EnergyDisplayPage extends StatefulWidget {
  var datas;

  EnergyDisplayPage({required this.datas});

  @override
  State<EnergyDisplayPage> createState() => _EnergyDisplayPageState();
}

class _EnergyDisplayPageState extends State<EnergyDisplayPage> {
  bool _isRefreshing = false; // Track the refreshing state

  @override
  Widget build(BuildContext context) {
    FetchingApi api_fetch = FetchingApi();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Energy Monitor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(4, 8),
                  blurRadius: 5,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Energy Reading',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 30),
                // Animation part
                AnimatedOpacity(
                  opacity: _isRefreshing ? 0.3 : 1.0, // Fade effect for refresh
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    '${widget.datas["energy"]} J',
                    style: TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _isRefreshing ? 0.3 : 1.0,
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'Last updated: ${_isRefreshing ? "Refreshing..." : "Just now"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isRefreshing = true; // Set refreshing state to true
          });

          // Simulate a delay to show the refreshing animation
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              // Update the data and set refreshing state to false
              api_fetch.fetchData();
              _isRefreshing = false;
            });
          });
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(
          Icons.refresh,
          size: 28,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
