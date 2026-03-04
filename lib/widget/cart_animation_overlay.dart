// // cart_animation_overlay.dart - Fixed overlay scrolling issue

// import 'package:flutter/material.dart';
// import 'dart:math' show cos, sin;

// class CartAnimationOverlay {
//   static OverlayEntry? _overlayEntry;

//   static void showAddToCartAnimation({
//     required BuildContext context,
//     required GlobalKey itemKey,
//     required GlobalKey cartKey,
//     required String imageUrl,
//     VoidCallback? onComplete,
//   }) {
//     _overlayEntry?.remove();

//     final RenderBox? itemBox = itemKey.currentContext?.findRenderObject() as RenderBox?;
//     final RenderBox? cartBox = cartKey.currentContext?.findRenderObject() as RenderBox?;

//     if (itemBox == null || cartBox == null) {
//       onComplete?.call();
//       return;
//     }

//     final itemPosition = itemBox.localToGlobal(Offset.zero);
//     final cartPosition = cartBox.localToGlobal(Offset.zero);
//     final itemSize = itemBox.size;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => _FlyingItemWidget(
//         startPosition: itemPosition,
//         endPosition: cartPosition,
//         itemSize: itemSize,
//         imageUrl: imageUrl,
//         onComplete: () {
//           _overlayEntry?.remove();
//           _overlayEntry = null;
//           onComplete?.call();
//         },
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }
// }

// class _FlyingItemWidget extends StatefulWidget {
//   final Offset startPosition;
//   final Offset endPosition;
//   final Size itemSize;
//   final String imageUrl;
//   final VoidCallback onComplete;

//   const _FlyingItemWidget({
//     required this.startPosition,
//     required this.endPosition,
//     required this.itemSize,
//     required this.imageUrl,
//     required this.onComplete,
//   });

//   @override
//   State<_FlyingItemWidget> createState() => _FlyingItemWidgetState();
// }

// class _FlyingItemWidgetState extends State<_FlyingItemWidget> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _curveAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

//     _curveAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);

//     _scaleAnimation = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 15),
//       TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 0.2).chain(CurveTween(curve: Curves.easeInCubic)), weight: 85),
//     ]).animate(_controller);

//     _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     _controller.forward().then((_) => widget.onComplete());
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Offset _calculatePosition(double t) {
//     final dx = widget.startPosition.dx + (widget.endPosition.dx - widget.startPosition.dx) * t;

//     // Higher parabolic arc
//     final midY = (widget.startPosition.dy + widget.endPosition.dy) / 2 - 100;
//     final dy =
//         widget.startPosition.dy +
//         (midY - widget.startPosition.dy) * (1 - (t - 0.5).abs() * 2) +
//         (widget.endPosition.dy - widget.startPosition.dy) * t;

//     return Offset(dx, dy);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final position = _calculatePosition(_curveAnimation.value);

//         return Positioned(
//           left: position.dx,
//           top: position.dy,
//           child: IgnorePointer(
//             child: Transform.scale(
//               scale: _scaleAnimation.value,
//               child: Opacity(
//                 opacity: _opacityAnimation.value,
//                 child: Container(
//                   width: widget.itemSize.width * 0.5,
//                   height: widget.itemSize.width * 0.5,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 15))],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: Stack(
//                       children: [
//                         Image.network(
//                           widget.imageUrl,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               color: Colors.grey.shade300,
//                               child: const Icon(Icons.restaurant, color: Colors.grey),
//                             );
//                           },
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: Colors.pink.withOpacity(0.6), width: 2),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ============================================
// // CART BADGE ANIMATION
// // ============================================

// class AnimatedCartBadge extends StatefulWidget {
//   final int itemCount;
//   final GlobalKey badgeKey;

//   const AnimatedCartBadge({super.key, required this.itemCount, required this.badgeKey});

//   @override
//   State<AnimatedCartBadge> createState() => _AnimatedCartBadgeState();
// }

// class _AnimatedCartBadgeState extends State<AnimatedCartBadge> with TickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late AnimationController _shakeController;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _shakeAnimation;
//   int _previousCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _previousCount = widget.itemCount;

//     _pulseController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
//     _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

//     _pulseAnimation = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
//       TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 50),
//     ]).animate(_pulseController);

//     _shakeAnimation = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.1), weight: 25),
//       TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: -0.1), weight: 25),
//       TweenSequenceItem(tween: Tween<double>(begin: -0.1, end: 0.1), weight: 25),
//       TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: 0.0), weight: 25),
//     ]).animate(_shakeController);
//   }

//   @override
//   void didUpdateWidget(AnimatedCartBadge oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.itemCount != _previousCount) {
//       _pulseController.forward(from: 0.0);
//       _shakeController.forward(from: 0.0);
//       _previousCount = widget.itemCount;
//     }
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _shakeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.itemCount == 0) return const SizedBox.shrink();

//     return AnimatedBuilder(
//       animation: Listenable.merge([_pulseAnimation, _shakeAnimation]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _pulseAnimation.value,
//           child: Transform.rotate(
//             angle: _shakeAnimation.value,
//             child: Container(
//               key: widget.badgeKey,
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(colors: [Colors.red, Colors.pink], begin: Alignment.topLeft, end: Alignment.bottomRight),
//                 shape: BoxShape.circle,
//                 boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2))],
//               ),
//               constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
//               child: Center(
//                 child: Text(
//                   '${widget.itemCount}',
//                   style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
