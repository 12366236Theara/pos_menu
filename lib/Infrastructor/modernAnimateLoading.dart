import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ModernAnimateLoading extends StatelessWidget {
  String? title;

  ModernAnimateLoading({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 80, height: 80, child: Lottie.asset('assets/lottie/loading.json')),
                const SizedBox(height: 16),
                Text(
                  title ?? "Loading",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Modern Loading Dialog with blur background
  void showLoading(BuildContext context, String content, {int? layerContext, String? data, bool dismiss = false}) async {
    showDialog(
      context: context,
      barrierDismissible: dismiss,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => PopScope(
        canPop: false,
        onPopInvoked: (v) {
          if (!v && dismiss) {
            Navigator.pop(context);
          }
        },
        child: _ModernLoadingDialog(content: content, animationType: _AnimationType.loading),
      ),
    );
  }

  /// Modern Searching Dialog
  void showSearching(BuildContext context, String content, {int? layerContext, String? data, bool dismiss = false}) async {
    showDialog(
      context: context,
      barrierDismissible: dismiss,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => PopScope(
        canPop: false,
        child: _ModernLoadingDialog(content: content, animationType: _AnimationType.searching),
      ),
    );
  }

  /// Modern Printing Dialog
  void showPrinting(BuildContext context, String content, {int? layerContext, String? data, bool dismiss = false}) async {
    showDialog(
      context: context,
      barrierDismissible: dismiss,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => PopScope(
        canPop: false,
        onPopInvoked: (v) {
          if (!v && dismiss) {
            Navigator.pop(context);
          }
        },
        child: _ModernLoadingDialog(content: content, animationType: _AnimationType.printing),
      ),
    );
  }

  /// Modern Processing Dialog (alternative style)
  void showProcessing(BuildContext context, String content, {bool dismiss = false}) async {
    showDialog(
      context: context,
      barrierDismissible: dismiss,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => PopScope(
        canPop: false,
        child: _ModernLoadingDialog(content: content, animationType: _AnimationType.processing),
      ),
    );
  }
}

enum _AnimationType { loading, searching, printing, processing }

class _ModernLoadingDialog extends StatefulWidget {
  final String content;
  final _AnimationType animationType;

  const _ModernLoadingDialog({required this.content, required this.animationType});

  @override
  State<_ModernLoadingDialog> createState() => _ModernLoadingDialogState();
}

class _ModernLoadingDialogState extends State<_ModernLoadingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    switch (widget.animationType) {
      case _AnimationType.loading:
        return Lottie.asset('assets/lottie/loading.json', width: 80, height: 80);
      case _AnimationType.searching:
        return Lottie.asset('assets/lottie/searching.json', width: 100, height: 100);
      case _AnimationType.printing:
        return Lottie.asset('assets/lottie/printing.json', width: 80, height: 80);
      case _AnimationType.processing:
        return Lottie.asset('assets/lottie/loading.json', width: 80, height: 80);
    }
  }

  Color _getAccentColor() {
    switch (widget.animationType) {
      case _AnimationType.loading:
        return Colors.blue;
      case _AnimationType.searching:
        return Colors.purple;
      case _AnimationType.printing:
        return Colors.green;
      case _AnimationType.processing:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300, minWidth: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 15))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Icon Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: _getAccentColor().withOpacity(0.1), shape: BoxShape.circle),
                    child: _buildLottieAnimation(),
                  ),
                  const SizedBox(height: 24),
                  // Loading Text
                  Text(
                    widget.content,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Animated Progress Bar
                  _AnimatedProgressBar(color: _getAccentColor()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated Progress Bar Widget
class _AnimatedProgressBar extends StatefulWidget {
  final Color color;

  const _AnimatedProgressBar({required this.color});

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(color: widget.color.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
              ),
              // Animated Progress
              FractionallySizedBox(
                widthFactor: _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [BoxShadow(color: widget.color.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 0))],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Minimal Loading Dialog (Alternative Style)
class MinimalLoadingDialog {
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                ),
                if (message != null) ...[const SizedBox(height: 16), Text(message, style: const TextStyle(fontSize: 14, color: Colors.black87))],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton Loading Widget (for inline loading states)
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({super.key, required this.width, required this.height, this.borderRadius});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = widget.height;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Calculate gradient stops ensuring they're always valid
          final animValue = _animation.value;
          final stops = [(animValue - 0.3).clamp(0.0, 1.0), animValue.clamp(0.0, 1.0), (animValue + 0.3).clamp(0.0, 1.0)];

          // Ensure stops are monotonically increasing
          final validStops = [
            stops[0],
            stops[1] > stops[0] ? stops[1] : stops[0] + 0.01,
            stops[2] > stops[1] ? stops[2] : (stops[1] > stops[0] ? stops[1] + 0.01 : stops[0] + 0.02),
          ];

          return Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
                stops: validStops,
              ),
            ),
          );
        },
      ),
    );
  }
}
