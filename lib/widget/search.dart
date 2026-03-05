import 'package:flutter/material.dart';
import 'package:pos_menu/Extension/appColorsExtension.dart';

class Search extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const Search({super.key, required this.hint, required this.controller, this.onChanged, this.onClear});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _glowAnim = CurvedAnimation(parent: _glowCtrl, curve: Curves.easeOutCubic);

    _focusNode.addListener(() {
      final focused = _focusNode.hasFocus;
      setState(() => _isFocused = focused);
      focused ? _glowCtrl.forward() : _glowCtrl.reverse();
    });

    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final pink = Theme.of(context).colorScheme.primary; // ← was static const _pink
    final hintColor = context.appColors.textHint; // ← was Colors.grey.shade400
    final textColor = context.appColors.textPrimary; // ← was Color(0xFF1A1D2E)

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (context, child) {
          return Container(
            height: 50,
            decoration: BoxDecoration(
              color: context.appColors.surface, // ← was context.appColors.header (surface fits better for input)
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isFocused
                    ? pink.withOpacity(0.45) // ← pink border on focus
                    : context.appColors.border, // ← theme border at rest
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(color: pink.withOpacity(0.10 * _glowAnim.value), blurRadius: 18, spreadRadius: 0, offset: const Offset(0, 4)),
                BoxShadow(color: Colors.black.withOpacity(0.04 * (1 - _glowAnim.value)), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: child,
          );
        },
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: (v) {
            setState(() {});
            widget.onChanged?.call(v);
          },
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor, // ← was Color(0xFF1A1D2E)
          ),

          decoration: InputDecoration(
            hintText: widget.hint,

            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: hintColor, // ← was Colors.grey.shade400
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.search_rounded,
                  key: ValueKey(_isFocused),
                  color: _isFocused ? pink : hintColor, // ← was _pink : Colors.grey.shade400
                  size: 22,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 46),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: hasText
                  ? _ClearButton(key: const ValueKey('clear'), onTap: _clearSearch)
                  : Padding(
                      key: const ValueKey('filter'),
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(
                        Icons.tune_rounded,
                        color: hintColor, // ← was Colors.grey.shade400
                        size: 20,
                      ),
                    ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),

            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          ),
        ),
      ),
    );
  }
}

class _ClearButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ClearButton({super.key, required this.onTap});

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final pink = Theme.of(context).colorScheme.primary; // ← was Color(0xFFE8316A)
    final iconColor = context.appColors.textSecondary; // ← was Colors.grey.shade500
    final idleBg = context.appColors.surface; // ← was Colors.grey.shade200

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: _hovered ? pink.withOpacity(0.12) : idleBg, // ← was hardcoded pink tint / grey.shade200
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              size: 15,
              color: _hovered ? pink : iconColor, // ← was Color(0xFFE8316A) : Colors.grey.shade500
            ),
          ),
        ),
      ),
    );
  }
}
