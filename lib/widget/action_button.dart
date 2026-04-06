import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String icon;
  final VoidCallback? onTap;

  const ActionButton({super.key, required this.icon, this.onTap});

  @override
  State<ActionButton> createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<Locale>(
        onSelected: (Locale locale) async {
          await EasyLocalization.of(context)!.setLocale(locale);
          widget.onTap?.call();
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
          PopupMenuItem(
            value: const Locale('en'),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage("assets/en-flag.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'English',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                if (currentLocale.languageCode == 'en')
                  const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
          PopupMenuItem(
            value: const Locale('km'),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage("assets/kh-flag.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'ភាសាខ្មែរ',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                if (currentLocale.languageCode == 'km')
                  const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
          PopupMenuItem(
            value: const Locale('zh'),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage("assets/cn-flagg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '中文',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                if (currentLocale.languageCode == 'zh')
                  const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ],
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(_isHovered ? 0.3 : 0.2),
                blurRadius: _isHovered ? 8 : 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: currentLocale.languageCode == 'en'
                      ? const AssetImage("assets/en-flag.png")
                      : currentLocale.languageCode == 'zh'
                          ? const AssetImage("assets/cn-flagg.jpg")
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