import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/model/category/category_model.dart';

class Category extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final Function(String categoryName, String? categoryCode) onSelected;
  final bool isScrolled;

  const Category({super.key, required this.categories, required this.selectedCategory, required this.onSelected, this.isScrolled = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(
          context,
        ).copyWith(scrollbars: false, dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _CategoryChip(title: 'All', isSelected: selectedCategory == 'All', onTap: () => onSelected('All', null));
            }
            final cat = categories[index - 1];
            final name = cat.descEn ?? cat.descKh ?? '';
            return _CategoryChip(title: name, isSelected: selectedCategory == name, onTap: () => onSelected(name, cat.id.toString()));
          },
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  static const _pink = Color(0xFFE8316A);

  const _CategoryChip({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedBg = isDark ? const Color(0xFF2A2D3E) : const Color(0xFFF2F2F7);
    final unselectedText = isDark ? const Color(0xFFB0B3C6) : const Color(0xFF6B6E82);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? _pink : unselectedBg,
            borderRadius: BorderRadius.circular(34),
            boxShadow: isSelected ? const [BoxShadow(color: Color(0x40E8316A), blurRadius: 8, offset: Offset(0, 3))] : const [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : unselectedText,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12.5,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
