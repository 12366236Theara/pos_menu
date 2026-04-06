import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Extension/appColorsExtension.dart';
import 'package:pos_menu/model/menu/menu_model.dart';

/// Call this from anywhere:
class ItemDetailDialog {
  static void show(BuildContext context, {required MenuModel item}) {
    final cardColor = Theme.of(context).cardTheme.color;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) {
        final size = MediaQuery.of(context).size;
        final isPhone = size.width < 600;

        final dialogConstraint = BoxConstraints(
          maxHeight: isPhone ? size.height * 0.8 : 700,
          minHeight: isPhone ? size.height * 0.6 : 650,
          maxWidth: isPhone ? size.width * 0.95 : 500,
          minWidth: isPhone ? size.width * 0.9 : 480,
        );

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: dialogConstraint,
            child: _ItemDetailSheet(item: item),
          ),
        );
      },
    );
  }
}

class _ItemDetailSheet extends StatefulWidget {
  final MenuModel item;
  const _ItemDetailSheet({required this.item});

  @override
  State<_ItemDetailSheet> createState() => _ItemDetailSheetState();
}

class _ItemDetailSheetState extends State<_ItemDetailSheet> with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _heroCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _pink = Color(0xFFE8316A);
  static const _dark = Color(0xFF1A1D2E);
  static const _lightBg = Color(0xFFF8F9FA);

  String get _imageUrl => '${Domain.baseUrl}/${widget.item.itemImg ?? ''}';

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _scaleAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutQuint);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );

    _entryCtrl.forward();
    Future.delayed(const Duration(milliseconds: 100), () => _heroCtrl.forward());
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2F3E) : Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar with close button
                  _buildHandleBar(context),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Image with zoom effect
                          _HeroImage(
                            imageUrl: _imageUrl,
                            heroCtrl: _heroCtrl,
                          ),

                          // Content Padding
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category & Stock Status Row
                                _buildHeaderRow(),

                                const SizedBox(height: 16),

                                // Item Name & Code
                                _buildTitleSection(textColor),

                                const SizedBox(height: 20),

                                _buildPriceSection(),

                                const SizedBox(height: 24),

                                // Divider
                                Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.withOpacity(0.1),
                                        Colors.grey.withOpacity(0.3),
                                        Colors.grey.withOpacity(0.1),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 20,
                                      color: _pink,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'title.ព័ត៌មានលម្អិត'.tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Detail Chips Grid
                                _DetailGrid(item: widget.item),

                                const SizedBox(height: 16),

                                // Additional Info if available

                                const SizedBox(height: 24),
                              ],
                            ),
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
    );
  }

  Widget _buildHandleBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
              ),
            ),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    final hasCategory = (widget.item.catDescEn ?? '').isNotEmpty;
    
    return Row(
      children: [
        if (hasCategory)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_rounded,
                  size: 12,
                  color: _pink,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.item.catDescEn!,
                  style: const TextStyle(
                    color: _pink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle_rounded,
                size: 8,
                color: Colors.green,
              ),
              SizedBox(width: 4),
              Text(
                'label.ក្នុងស្តុក'.tr(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item.itemDesc ?? 'Unnamed Item',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: textColor,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.qr_code_scanner_rounded,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'SKU: ${widget.item.itemCode ?? '—'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _pink.withOpacity(0.05),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _pink.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'label.តម្លៃទំនិញ'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${widget.item.itemPrice1?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: _pink,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (widget.item.itemPrice2 != null && widget.item.itemPrice2! > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Special Price',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${widget.item.itemPrice2!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Hero Image with improved animation ──────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final String imageUrl;
  final AnimationController heroCtrl;

  const _HeroImage({
    required this.imageUrl,
    required this.heroCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: heroCtrl,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (0.1 * (1 - heroCtrl.value)),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: AspectRatio(
              aspectRatio: 14 / 12,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image with improved loading
                  _buildImage(),

                  // Gradient overlays for better text contrast
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top gradient for depth
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      frameBuilder: (_, child, frame, sync) {
        if (sync) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFFF5F5F7),
          child: Center(
            child: Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: const Color(0xFFE8316A),
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF5F5F7),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.image_not_supported_rounded,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Image not available',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _DetailGrid extends StatelessWidget {
  final MenuModel item;
  const _DetailGrid({required this.item});

  @override
  Widget build(BuildContext context) {
    final details = <_DetailItem>[];

    // Add all available details
    if ((item.catDescEn ?? '').isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.category_rounded,
        label: 'Category'.tr(),
        value: item.catDescEn!,
        color: const Color(0xFF6C5CE7),
      ));
    }

    if ((item.itemType ?? '').isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.inventory_2_rounded,
        label: 'label.ប្រភេទ៖'.tr(),
        value: item.itemType!,
        color: const Color(0xFF00B894),
      ));
    }
    if ((item.itemBcode ?? '').isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.description_rounded,
        label: 'label.Barcode ទំនិញ'.tr(),
        value: item.itemBcode!.length > 30 
            ? '${item.itemBcode!.substring(0, 30)}...' 
            : item.itemBcode!,
        color: const Color(0xFF0984E3),
      ));
    }

    if ((item.itemCode ?? '').isNotEmpty) {
      details.add(_DetailItem(
        icon: Icons.qr_code_rounded,
        label: 'Item Code'.tr(),
        value: item.itemCode!,
        color: const Color(0xFFE17055),
      ));
    }

    if (item.itemPrice2 != null && item.itemPrice2! > 0) {
      details.add(_DetailItem(
        icon: Icons.sell_rounded,
        label: 'Price 2',
        value: '\$${item.itemPrice2!.toStringAsFixed(2)}',
        color: const Color(0xFFFDCB6E),
      ));
    }

    

    if (details.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        return _DetailCard(item: details[index]);
      },
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _DetailCard extends StatelessWidget {
  final _DetailItem item;
  const _DetailCard({required this.item});
  static const _dark = Color(0xFF1A1D2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Colored accent
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 14,
                      color: item.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}