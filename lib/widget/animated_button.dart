// Animated Button Widget
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPress;
  final String text;
  final Color colorBoder;

  const AnimatedButton({super.key, required this.onPress, required this.text, required this.colorBoder});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: () {
          setState(() => _isPressed = true);
          _controller.forward().then((_) {
            _controller.reverse();
            widget.onPress();
            Future.delayed(Duration(milliseconds: 150), () {
              if (mounted) setState(() => _isPressed = false);
            });
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.colorBoder,
          foregroundColor: Colors.white,
          elevation: _isPressed ? 2 : 4,
          shadowColor: widget.colorBoder.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
