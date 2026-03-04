import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum MediaType { image, video }

class ModernPopupDialog {
  /// Modern popup with animations
  /// success: 0=error, 1=success, 2=warning, 3=processing, 4=printing
  static Future<bool?> showPopup(
    BuildContext context,
    String content, {
    int? layerContext,
    dynamic data,
    bool pushToLogin = false,
    bool exitApp = false,
    bool dismiss = false,
    int success = 2,
    String? title,
  }) async {
    return showDialog<bool>(
      barrierDismissible: dismiss,
      context: context,
      builder: (_) => _ModernAlertDialog(
        title: title ?? 'msg.ព័ត៌មាន',
        content: content,
        success: success,
        onConfirm: () {
          if (exitApp) {
            exit(0);
          } else if (layerContext != null) {
            for (int i = 0; i < layerContext; i++) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, i == layerContext - 1 ? data : null);
              }
            }
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, data);
            }
          }
        },
      ),
    );
  }

  /// Modern Yes/No confirmation dialog
  static Future<bool> yesNoPrompt(
    BuildContext context, {
    String? content,
    String? title,
    bool dismiss = true,
    Function? onOk,
    Function? onCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: dismiss,
      builder: (_) => _ModernConfirmDialog(
        title: title ?? 'msg.ព័ត៌មាន',
        content: content ?? 'msg.តើអ្នកបានត្រួតពិនិត្យរួចរាល់ហើយមែនទេ?',
        onConfirm: () {
          if (onOk != null) {
            onOk();
          } else {
            Navigator.pop(context, true);
          }
        },
        onCancel: () {
          if (onCancel != null) {
            onCancel();
          } else {
            Navigator.pop(context, false);
          }
        },
      ),
    );
    return result ?? false;
  }

  /// Modern media picker for web
  static Future<File?> chooseMediaInWindow({
    required BuildContext context,
    String imageFileName = 'image_slide.png',
    String videoFileName = 'video_slide.mp4',
  }) async {
    final MediaType? choice = await showDialog<MediaType>(context: context, builder: (ctx) => _ModernMediaTypeDialog());

    if (choice == null) return null;

    FilePickerResult? result;
    if (choice == MediaType.video) {
      result = await FilePicker.platform.pickFiles(type: FileType.video, allowedExtensions: ['mp4', 'mov', 'avi']);
    } else {
      result = await FilePicker.platform.pickFiles(type: FileType.image, allowedExtensions: ['png', 'jpg', 'jpeg']);
    }

    if (result?.files.single.path != null) {
      return File(result!.files.single.path!);
    }
    return null;
  }

  /// Modern image picker for web
  static Future<File?> chooseImageInWindow({required BuildContext context}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

    if (result?.files.single.path != null) {
      return File(result!.files.single.path!);
    }
    return null;
  }

  /// Modern multiple images picker for web
  static Future<List<File>> chooseImagesInWindow({required BuildContext context}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);

    List<File> files = [];
    final allowedExtensions = ['jpg', 'jpeg', 'png'];

    if (result != null) {
      for (var f in result.files) {
        if (f.path != null) {
          final extension = f.extension?.toLowerCase();
          if (extension != null && allowedExtensions.contains(extension)) {
            files.add(File(f.path!));
          }
        }
      }
    }
    return files;
  }
}

// Modern Alert Dialog Widget
class _ModernAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final int success;
  final VoidCallback onConfirm;

  const _ModernAlertDialog({required this.title, required this.content, required this.success, required this.onConfirm});

  @override
  State<_ModernAlertDialog> createState() => _ModernAlertDialogState();
}

class _ModernAlertDialogState extends State<_ModernAlertDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIcon() {
    switch (widget.success) {
      case 0: // Error
        return Lottie.asset('assets/lottie/error.json', width: 80, repeat: false);
      case 1: // Success
        return Lottie.asset('assets/lottie/success.json', width: 80, repeat: false);
      case 2: // Warning
        return Lottie.asset('assets/lottie/warning.json', width: 80, repeat: false);
      case 3: // Processing
        return Image.asset('images/processing.png', width: 80);
      case 4: // Printing
        return Lottie.asset('assets/lottie/printing.json', width: 80, repeat: false);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.content,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _ModernButton(text: "btn.យល់ព្រម", onPressed: widget.onConfirm, isPrimary: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modern Confirmation Dialog
class _ModernConfirmDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ModernConfirmDialog({required this.title, required this.content, required this.onConfirm, required this.onCancel});

  @override
  State<_ModernConfirmDialog> createState() => _ModernConfirmDialogState();
}

class _ModernConfirmDialogState extends State<_ModernConfirmDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/warning.json', width: 80, repeat: false),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                widget.content,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _ModernButton(text: "បោះបង់", onPressed: widget.onCancel, isPrimary: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ModernButton(text: "btn.យល់ព្រម", onPressed: widget.onConfirm, isPrimary: true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modern Media Type Dialog
class _ModernMediaTypeDialog extends StatefulWidget {
  @override
  State<_ModernMediaTypeDialog> createState() => _ModernMediaTypeDialogState();
}

class _ModernMediaTypeDialogState extends State<_ModernMediaTypeDialog> {
  MediaType? _hoveredType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ជ្រើសរើសប្រភេទស្លាយ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: _MediaTypeCard(
                    icon: Icons.image_rounded,
                    label: 'រូបភាព',
                    color: Colors.blue,
                    isHovered: _hoveredType == MediaType.image,
                    onHover: (hover) {
                      setState(() => _hoveredType = hover ? MediaType.image : null);
                    },
                    onTap: () => Navigator.pop(context, MediaType.image),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MediaTypeCard(
                    icon: Icons.videocam_rounded,
                    label: 'វីដេអូ',
                    color: Colors.purple,
                    isHovered: _hoveredType == MediaType.video,
                    onHover: (hover) {
                      setState(() => _hoveredType = hover ? MediaType.video : null);
                    },
                    onTap: () => Navigator.pop(context, MediaType.video),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Media Type Card Widget
class _MediaTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isHovered;
  final Function(bool) onHover;
  final VoidCallback onTap;

  const _MediaTypeCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isHovered,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isHovered ? color.withOpacity(0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isHovered ? color : Colors.grey.shade300, width: isHovered ? 2 : 1),
            boxShadow: isHovered ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))] : [],
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isHovered ? color : Colors.grey.shade200, shape: BoxShape.circle),
                child: Icon(icon, size: 32, color: isHovered ? Colors.white : Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isHovered ? color : Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modern Button Widget
class _ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ModernButton({required this.text, required this.onPressed, this.isPrimary = true});

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered ? primaryColor.withOpacity(0.9) : primaryColor)
                : (_isHovered ? Colors.grey.shade100 : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.isPrimary ? primaryColor : Colors.grey.shade300, width: widget.isPrimary ? 0 : 1.5),
            boxShadow: _isHovered
                ? [BoxShadow(color: (widget.isPrimary ? primaryColor : Colors.grey).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: widget.isPrimary ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
