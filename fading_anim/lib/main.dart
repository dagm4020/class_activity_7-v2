import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FadingTextAnimation(),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  bool _isExpanded = false;
  Offset _offset = Offset.zero; 
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), 
      end: Offset.zero, 
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward(); 
      } else {
        _controller.reverse(); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
      ),
      body: Stack(
        children: [
          Container(color: Colors.white), 

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    '...Hello',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _isExpanded ? 24 : 0),
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOutCirc,
                  builder: (context, fontSize, child) {
                    return Text(
                      '...don\'t mind me, just chilling',
                      style: TextStyle(fontSize: fontSize),
                    );
                  },
                ),
   
                SlideTransition(
                  position: _slideAnimation,
                  child: Visibility(
                    visible: _isExpanded, 
                    child: const Text(
                      'You can grab my head and move it around by the way...',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 20), 
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _offset += details.delta; 
                    });
                  },
                  child: Transform.translate(
                    offset: _offset, 
                    child: Image.asset(
                      'img/obama.jpeg',
                      width: 300, 
                      height: 300, 
                      fit: BoxFit.cover, 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: toggleVisibility,
            child: Icon(Icons.visibility),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: toggleExpansion,
            child: Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
