import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/model/menu/menu_model.dart';

class MenuList extends StatefulWidget {
  final MenuModel item;
  final int index;
  final GlobalKey? cartIconKey;

  const MenuList({super.key, required this.item, this.index = 0, this.cartIconKey});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> with SingleTickerProviderStateMixin {
  final TextEditingController _quantityController = TextEditingController(text: '1');
  bool _isHovered = false;
  final bool _isAdding = false;
  bool _isVisible = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final GlobalKey _itemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initializeAnimations();

    // Start animation immediately for visible items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isVisible) {
        _triggerAnimation();
      }
    });
  }

  void initializeAnimations() {
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _triggerAnimation() {
    if (_isVisible) return;

    // Stagger animation based on index
    final delay = Duration(milliseconds: (widget.index % 10) * 40);

    Future.delayed(delay, () {
      if (mounted && !_isVisible) {
        setState(() => _isVisible = true);
        _controller.forward();
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MouseRegion(
            onEnter: (_) {
              if (mounted) setState(() => _isHovered = true);
            },
            onExit: (_) {
              if (mounted) setState(() => _isHovered = false);
            },
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: null, //  create new class for view detail item
              onLongPress: () {},
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.04),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: Offset(0, _isHovered ? 6 : 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          // Main Image with RepaintBoundary
                          RepaintBoundary(
                            child: ClipRRect(
                              key: _itemKey,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: _OptimizedImageWidget(imageUrl: '${Domain.baseUrl}/${widget.item.itemImg.toString()}', isHovered: _isHovered),
                              ),
                            ),
                          ),

                          // Hover Gradient Overlay
                          if (_isHovered)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.08)],
                                  ),
                                ),
                              ),
                            ),

                          // Adding State Overlay with Check Icon
                          if (_isAdding)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  color: Colors.black.withOpacity(0.15),
                                ),
                                child: Center(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutBack,
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.25), blurRadius: 10, spreadRadius: 1)],
                                          ),
                                          child: const Icon(Icons.check_rounded, color: Colors.green, size: 24),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Details Section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Description
                            Expanded(
                              child: Text(
                                widget.item.itemDesc ?? '',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2, color: Color(0xFF2D3142)),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Price and Cart Button Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Price Badge
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(horizontal: _isHovered ? 14 : 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: _isHovered
                                        ? [BoxShadow(color: Colors.pink.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
                                        : [],
                                  ),
                                  child: Text(
                                    '\$${widget.item.itemPrice?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),

                                // Add to Cart Button
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  width: (_isHovered || _isAdding) ? 34 : 36,
                                  height: (_isHovered || _isAdding) ? 34 : 36,
                                  decoration: BoxDecoration(
                                    color: _isAdding
                                        ? Colors.green.withOpacity(0.15)
                                        : _isHovered
                                        ? Colors.pink.withOpacity(0.15)
                                        : Colors.pink.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isAdding ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                                    size: 18,
                                    color: _isAdding ? Colors.green : Colors.pink,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// OPTIMIZED: Separated image widget with caching
class _OptimizedImageWidget extends StatelessWidget {
  final String imageUrl;
  final bool isHovered;

  const _OptimizedImageWidget({required this.imageUrl, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isHovered ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // Performance optimizations
        cacheWidth: 500,
        cacheHeight: 400,
        // Smooth loading
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;

          return AnimatedOpacity(opacity: frame == null ? 0 : 1, duration: const Duration(milliseconds: 200), curve: Curves.easeOut, child: child);
        },
        // Error handling
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu_rounded, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 4),
                  Text('Image not available', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
          );
        },
        // Loading indicator
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            color: Colors.grey.shade100,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade300),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
