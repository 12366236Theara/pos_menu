import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pos_menu/Extension/appColorsExtension.dart';
import 'package:pos_menu/model/category/category_model.dart';

class Category extends StatefulWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final Function(String categoryName, String? categoryCode) onSelected;

  final bool isScrolled;

  const Category({super.key, required this.categories, required this.selectedCategory, required this.onSelected, this.isScrolled = false});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didUpdateWidget(Category oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categories.length != widget.categories.length) {
      for (var c in _controllers) {
        c.dispose();
      }
      _initializeAnimations();
    }
  }

  void _initializeAnimations() {
    final total = widget.categories.length + 1;
    _controllers = List.generate(total, (_) => AnimationController(duration: const Duration(milliseconds: 400), vsync: this));
    _scaleAnimations = _controllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: c, curve: Curves.easeOutBack)))
        .toList();
    _fadeAnimations = _controllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 40), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      height: widget.isScrolled ? 30 : 20,
      margin: EdgeInsets.symmetric(vertical: widget.isScrolled ? 10 : 15),
      decoration: BoxDecoration(
        color: widget.isScrolled ? Colors.transparent : Colors.transparent,
        boxShadow: widget.isScrolled ? [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 3))] : [],
        border: widget.isScrolled ? Border(bottom: BorderSide(color: Colors.transparent, width: 1)) : Border.all(color: Colors.transparent),
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(scrollbars: false, dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: widget.categories.length + 1,

          itemBuilder: (context, index) {
            if (index == 0) {
              return ScaleTransition(
                scale: _scaleAnimations[index],
                child: FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: AnimatedCategoryChip(
                    title: 'All',
                    isSelected: widget.selectedCategory == 'All',
                    isScrolled: widget.isScrolled,
                    onTap: () => widget.onSelected('All', null),
                  ),
                ),
              );
            }

            final cat = widget.categories[index - 1];
            final name = cat.descEn ?? cat.descKh ?? '';
            final code = cat.id;
            final isSelected = widget.selectedCategory == name;

            return ScaleTransition(
              scale: _scaleAnimations[index],
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: AnimatedCategoryChip(
                  title: name,
                  isSelected: isSelected,
                  isScrolled: widget.isScrolled,
                  onTap: () => widget.onSelected(name, code.toString()),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedCategoryChip extends StatefulWidget {
  final bool isSelected;
  final bool isScrolled;
  final String title;
  final VoidCallback onTap;

  const AnimatedCategoryChip({super.key, required this.isSelected, required this.onTap, required this.title, this.isScrolled = false});

  @override
  State<AnimatedCategoryChip> createState() => _AnimatedCategoryChipState();
}

class _AnimatedCategoryChipState extends State<AnimatedCategoryChip> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rippleCtrl;
  late Animation<double> _rippleAnim;

  static const _pink = Color(0xFFE8316A);

  @override
  void initState() {
    super.initState();
    _rippleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(AnimatedCategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _rippleCtrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Compact dimensions when sticky
    final hPad = widget.isScrolled ? 20.0 : 18.0;
    final vPad = widget.isScrolled ? 10.0 : 11.0;
    final fontSize = widget.isScrolled ? (widget.isSelected ? 11.0 : 11.5) : (widget.isSelected ? 12.0 : 11.0);
    final textColor = context.appColors.textPrimary;
    final hintColor = context.appColors.textHint;
    final cart = context.appColors.card;
    return Padding(
      padding: EdgeInsets.only(right: 8, top: widget.isScrolled ? 8 : 0, bottom: widget.isScrolled ? 8 : 0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()..translate(0.0, _isHovered && !widget.isSelected ? -2.0 : 0.0),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            decoration: BoxDecoration(
              color: widget.isSelected ? _pink : cart,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.isSelected ? _pink : (widget.isScrolled ? Colors.grey.shade200 : Colors.grey.shade200),
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected ? _pink.withOpacity(0.28) : Colors.black.withOpacity(_isHovered ? 0.06 : 0.0),
                  blurRadius: widget.isSelected ? 12 : 8,
                  offset: Offset(0, widget.isSelected ? 4 : 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : textColor,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: fontSize,
                    letterSpacing: widget.isSelected ? 0.1 : 0,
                  ),
                  child: Text(widget.title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
