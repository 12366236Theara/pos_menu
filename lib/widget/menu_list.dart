import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/model/menu/menu_model.dart';
import 'package:pos_menu/widget/item_detailPage.dart';

class MenuList extends StatefulWidget {
  final MenuModel item;
  final int index;
  final GlobalKey? cartIconKey;

  const MenuList({super.key, required this.item, this.index = 0, this.cartIconKey});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isVisible = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isVisible) _triggerAnimation();
    });
  }

  void _initAnimations() {
    _controller = AnimationController(duration: const Duration(milliseconds: 450), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _triggerAnimation() {
    final delay = Duration(milliseconds: (widget.index % 12) * 35);
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

  void _openDetail() {
    ItemDetailDialog.show(context, item: widget.item);
  }

  String get _imageUrl => '${Domain.baseUrl}/${widget.item.itemImg ?? ''}';

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _openDetail,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()..translate(0.0, _isHovered ? -5.0 : 0.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.10 : 0.05),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: Offset(0, _isHovered ? 8 : 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Image Section ──
                      Expanded(
                        flex: 55,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _ItemImage(imageUrl: _imageUrl, isHovered: _isHovered),

                            // Gradient fade at bottom of image
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.18)],
                                  ),
                                ),
                              ),
                            ),

                            // Category Badge
                            if ((widget.item.catDescEn ?? '').isNotEmpty)
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    widget.item.catDescEn ?? '',
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // ── Details Section ──
                      Expanded(
                        flex: 45,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Expanded(
                                child: Text(
                                  widget.item.itemDesc ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    color: Color(0xFF1A1D2E),
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Price + Cart Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Price
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${widget.item.itemPrice1?.toStringAsFixed(2) ?? '0.00'}',
                                        style: const TextStyle(
                                          color: Color(0xFFE8316A),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final String imageUrl;
  final bool isHovered;
  const _ItemImage({required this.imageUrl, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isHovered ? 1.06 : 1.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        cacheWidth: 600,
        cacheHeight: 500,
        frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(opacity: frame == null ? 0.0 : 1.0, duration: const Duration(milliseconds: 250), child: child);
        },
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _ImagePlaceholder(
            progress: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
          );
        },
        errorBuilder: (_, __, ___) => const _ImageError(),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final double? progress;
  const _ImagePlaceholder({this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(value: progress, strokeWidth: 2.5, color: const Color(0xFFE8316A)),
        ),
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded, size: 36, color: Colors.grey.shade300),
            const SizedBox(height: 6),
            Text(
              'No Image',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
