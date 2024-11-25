import 'package:flutter/material.dart';
import 'package:synergy_app/main.dart';

class VoltageDisplayPage extends StatefulWidget {
  var datas;

  VoltageDisplayPage({super.key, required this.datas});

  @override
  State<VoltageDisplayPage> createState() => _VoltageDisplayPageState();
}

class _VoltageDisplayPageState extends State<VoltageDisplayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _scaleAnimation;
  bool _isRefreshing = false;
  var _previousVoltage;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blueAccent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
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
    _controller.forward(); // Start the animation when refreshing starts

    _previousVoltage = widget.datas["voltage"]; // Store the current voltage

    // Simulate the data fetching
    var newData = await FetchingApi().fetchData();

    setState(() {
      widget.datas = newData; // Update the data after the fetch
      _isRefreshing = false; // End refreshing
    });

    _controller.reverse(); // Reset the animation after refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voltage Monitor',
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: _backgroundColorAnimation
                .value, // Apply the background color animation
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Voltage Reading',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Voltage text with scaling animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          _isRefreshing
                              ? '$_previousVoltage V'
                              : '${widget.datas["voltage"]} V',
                          style: const TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Last updated: Just now',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (_) {
          // Start animation when the button is pressed
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 +
                  (_controller.value *
                      0.2), // Slightly increase scale during refresh
              child: FloatingActionButton(
                onPressed: _isRefreshing
                    ? null // Disable button when refreshing
                    : () async {
                        await _refreshData();
                      },
                backgroundColor:
                    _isRefreshing ? Colors.grey : Colors.lightBlueAccent,
                child: Transform.rotate(
                  angle: _controller.value *
                      2 *
                      3.14159, // Rotate button during refresh
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
