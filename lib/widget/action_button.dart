import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String icon;
  final VoidCallback? onTap; // Make it nullable since we handle it internally

  const ActionButton({super.key, required this.icon, this.onTap});

  @override
  State<ActionButton> createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          // Handle language toggle
          if (EasyLocalization.of(context)!.locale == const Locale('en')) {
            await EasyLocalization.of(context)!.setLocale(const Locale("km"));
          } else {
            await EasyLocalization.of(context)!.setLocale(const Locale("en"));
          }

          // Call the callback if provided
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(_isHovered ? 0.3 : 0.2), blurRadius: _isHovered ? 8 : 5, offset: const Offset(0, 2)),
            ],
          ),
          child: Center(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: EasyLocalization.of(context)!.locale == const Locale('en')
                      ? const AssetImage("assets/en-flag.png")
                      : const AssetImage("assets/kh-flag.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
