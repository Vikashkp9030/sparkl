import 'package:flutter/material.dart';

import 'feature/splace_screen/splace_screen.dart';

void main() => runApp(const MaterialApp(
      home: SparklUIScreen(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RelocateAnimationDemo(),
    );
  }
}

class RelocateAnimationDemo extends StatefulWidget {
  @override
  _RelocateAnimationDemoState createState() => _RelocateAnimationDemoState();
}

class _RelocateAnimationDemoState extends State<RelocateAnimationDemo> {
  bool _isMoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget Relocation Animation")),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            left: _isMoved ? 200.0 : 50.0,
            top: _isMoved ? 400.0 : 100.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isMoved = !_isMoved;
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: 100,
                height: _isMoved ? 40 : 100,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    "Move Me",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
