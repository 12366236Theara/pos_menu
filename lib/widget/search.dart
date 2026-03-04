import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const Search({super.key, required this.hint, required this.controller, this.onChanged, this.onClear});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isFocused ? Colors.pink.shade300 : Colors.grey.shade200, width: _isFocused ? 2 : 1),
          boxShadow: [
            BoxShadow(
              color: _isFocused ? Colors.pink.withOpacity(0.1) : Colors.black.withOpacity(0.03),
              blurRadius: _isFocused ? 12 : 8,
              offset: Offset(0, _isFocused ? 4 : 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2D3142)),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade400),
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.search_rounded, color: _isFocused ? Colors.pink.shade400 : Colors.grey.shade400, size: 24),
              ),
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? _ClearButton(onTap: _clearSearch)
                : Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.tune_rounded, color: Colors.grey.shade400, size: 22),
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}

class _ClearButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ClearButton({required this.onTap});

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: _isHovered ? Colors.pink.shade100 : Colors.grey.shade200, shape: BoxShape.circle),
            child: Icon(Icons.close_rounded, color: _isHovered ? Colors.pink.shade600 : Colors.grey.shade600, size: 16),
          ),
        ),
      ),
    );
  }
}
