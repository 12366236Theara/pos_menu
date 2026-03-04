import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pos_menu/model/category/category_model.dart';

class Category extends StatefulWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final Function(String categoryName, String? categoryCode) onSelected;

  const Category({super.key, required this.categories, required this.selectedCategory, required this.onSelected});

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
      for (var controller in _controllers) {
        controller.dispose();
      }
      _initializeAnimations();
    }
  }

  void _initializeAnimations() {
    final totalCount = widget.categories.length + 1;

    _controllers = List.generate(totalCount, (index) => AnimationController(duration: const Duration(milliseconds: 400), vsync: this));

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 40), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 15),
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
              final isSelected = widget.selectedCategory == 'All';
              return ScaleTransition(
                scale: _scaleAnimations[index],
                child: FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: AnimatedCategoryChip(title: 'All', isSelected: isSelected, onTap: () => widget.onSelected('All', null)),
                ),
              );
            }

            final categoryIndex = index - 1;
            final category = widget.categories[categoryIndex];
            final categoryName = category.descEn ?? category.descKh ?? '';
            final categoryCode = category.id;
            final isSelected = widget.selectedCategory == categoryName;

            return ScaleTransition(
              scale: _scaleAnimations[index],
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: AnimatedCategoryChip(
                  title: categoryName,
                  isSelected: isSelected,
                  onTap: () => widget.onSelected(categoryName, categoryCode.toString()),
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
  final String title;
  final VoidCallback onTap;

  const AnimatedCategoryChip({super.key, required this.isSelected, required this.onTap, required this.title});

  @override
  State<AnimatedCategoryChip> createState() => _AnimatedCategoryChipState();
}

class _AnimatedCategoryChipState extends State<AnimatedCategoryChip> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _rippleController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(AnimatedCategoryChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _rippleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()..translate(0.0, _isHovered && !widget.isSelected ? -2.0 : 0.0),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isSelected ? Colors.pink : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: widget.isSelected ? Colors.pink : Colors.grey.shade300, width: widget.isSelected ? 2 : 1),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected ? Colors.pink.withOpacity(0.3) : Colors.black.withOpacity(_isHovered ? 0.08 : 0.0),
                  blurRadius: widget.isSelected ? 12 : 8,
                  offset: Offset(0, widget.isSelected ? 4 : 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isSelected)
                  AnimatedBuilder(
                    animation: _rippleAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity((1 - _rippleAnimation.value) * 0.5), width: 2),
                        ),
                      );
                    },
                  ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.black87,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: widget.isSelected ? 14 : 13,
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
