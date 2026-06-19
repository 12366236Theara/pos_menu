import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Extension/appColorsExtension.dart';
import 'package:pos_menu/Extension/dynamic_icon_currency.dart';
import 'package:pos_menu/Infrastructor/styleColor.dart';
import 'package:pos_menu/model/menu/item_currency.dart';
import 'package:pos_menu/model/menu/menu_model.dart';
import 'package:pos_menu/widget/item_detailPage.dart';

class MenuList extends StatefulWidget {
  final MenuModel item;
  final GlobalKey? cartIconKey;
  ItemCurr? itemCurr;
  final int index;

  MenuList({super.key, required this.item, this.index = 0, this.cartIconKey, this.itemCurr});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> with SingleTickerProviderStateMixin {
  final bool _isHovered = false;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2130) : Colors.white;
    final textColor = context.appColors.textPrimary;
    final textPrimary = context.appColors.textPrimary;
    final textSecondary = isDark ? const Color(0xFF8A8EA8) : const Color(0xFFAAADB8);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => _openDetail(),
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, 4)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ──────────────────────────────────────────────
                Expanded(
                  flex: 56,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ItemImage(imageUrl: _imageUrl),
                      // category badge
                      if ((widget.item.catDescEn ?? '').isNotEmpty) Positioned(top: 9, left: 9, child: _Badge(label: widget.item.catDescEn ?? '')),
                    ],
                  ),
                ),

                // ── Details Section ──
                Expanded(
                  flex: 25,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.itemDesc ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              color: textColor, // ← was Color(0xFF1A1D2E)
                              letterSpacing: -0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.itemCurr != null)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "${CurrencyExtention.currencyIconSecond(currencyCode: widget.itemCurr?.type)} ${widget.itemCurr?.currValues}",
                                  style: StyleColor.textStyleKhmerContentAuto(bold: true, color: StyleColor.appBarColor),
                                ),
                              ),
                            if (widget.itemCurr == null)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CurrencyText(
                                  price: Decimal.parse(widget.item.itemPrice1.toString()),
                                  style: StyleColor.textStyleKhmerContentAuto(bold: true, color: StyleColor.appBarColor),
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
    );
  }
}

// ── Badge ─────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ── Image ─────────────────────────────────────────────────────────────────────

class _ItemImage extends StatelessWidget {
  final String imageUrl;
  const _ItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 400,
      memCacheHeight: 340,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => _ImagePlaceholder(isDark: isDark),
      errorWidget: (_, _, _) => _ImagePlaceholder(isDark: isDark),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final bool isDark;
  const _ImagePlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF252837) : const Color(0xFFF5F5F8);
    final iconColor = isDark ? const Color(0xFF383B50) : const Color(0xFFE2E2E8);

    return Container(
      color: bg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded, size: 36, color: iconColor),
            const SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(fontSize: 10, color: iconColor, fontWeight: FontWeight.w600, letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}
