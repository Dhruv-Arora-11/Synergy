import 'package:flutter/material.dart';
import 'package:synergy_app/main.dart';

class CurrentDisplayPage extends StatefulWidget {
  var datas;

  CurrentDisplayPage({super.key, required this.datas});

  @override
  State<CurrentDisplayPage> createState() => _CurrentDisplayPageState();
}

class _CurrentDisplayPageState extends State<CurrentDisplayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    _controller.repeat();

    // Simulate data fetching
    var newData = await FetchingApi().fetchData();

    setState(() {
      widget.datas = newData;
      _isRefreshing = false;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Current Monitor',
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(4, 8),
                  blurRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Current Reading',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 30),
                // Add animated opacity or bounce for effect
                AnimatedOpacity(
                  opacity: _isRefreshing ? 0.3 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    '${widget.datas["current"]} A',
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _isRefreshing ? 0.3 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: const Text(
                    'Last updated: Just now',
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
        onPressed: _isRefreshing
            ? null // Disable button while refreshing
            : () async {
                await _refreshData();
              },
        backgroundColor: _isRefreshing
            ? Colors.grey
            : Colors.lightBlueAccent, // Change color
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159, // Full rotation
              child: const Icon(
                Icons.refresh,
                size: 28,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
