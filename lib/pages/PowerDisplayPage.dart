import 'package:flutter/material.dart';
import 'package:synergy_app/main.dart';

class PowerDisplayPage extends StatefulWidget {
  var datas;

  PowerDisplayPage({super.key, required this.datas});

  @override
  State<PowerDisplayPage> createState() => _PowerDisplayPageState();
}

class _PowerDisplayPageState extends State<PowerDisplayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textRotationAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Animation for background color change
    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blueAccent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Scale animation for power text
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Rotation animation for power reading text
    _textRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This method should handle the API call and data update
  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    _controller.repeat();

    // Simulate data fetching by calling the API
    var newData = await FetchingApi()
        .fetchData(); // Ensure you have the correct FetchingApi

    setState(() {
      widget.datas = newData; // Update the widget with the new data
      _isRefreshing = false;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Power Monitor',
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
            color: _backgroundColorAnimation.value, // Background color change
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
                        'Power Reading',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Apply text scaling and rotation for more impact
                      Transform.rotate(
                        angle: _textRotationAnimation.value,
                        child: ScaleTransition(
                          scale: _scaleAnimation, // This is the fix
                          child: Text(
                            '${widget.datas["power"]} W',
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
          // Add a ripple effect when the button is pressed
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
              scale:
                  1 + (_controller.value * 0.3), // Scale the button on refresh
              child: FloatingActionButton(
                onPressed: _isRefreshing
                    ? null // Disable button while refreshing
                    : () async {
                        await _refreshData();
                      },
                backgroundColor:
                    _isRefreshing ? Colors.grey : Colors.lightBlueAccent,
                child: Transform.rotate(
                  angle: _controller.value * 2 * 3.14159, // Full rotation
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
