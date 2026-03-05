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

      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        final size = MediaQuery.of(context).size;
        final isPhone = size.width < 600;

        final dialogConstraint = BoxConstraints(
          maxHeight: isPhone ? size.height * 0.65 : 650,
          minHeight: isPhone ? size.height * 0.5 : 650,
          maxWidth: isPhone ? size.width : 450,
          minWidth: isPhone ? size.width * 0.85 : 450,
        );

        return AlertDialog(
          backgroundColor: cardColor,
          content: ConstrainedBox(
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
  final int _qty = 1;

  late AnimationController _entryCtrl;
  late AnimationController _btnCtrl;
  late Animation<double> _sheetAnim;
  late Animation<double> _contentFade;

  static const _pink = Color(0xFFE8316A);
  static const _dark = Color(0xFF1A1D2E);

  String get _imageUrl => '${Domain.baseUrl}/${widget.item.itemImg ?? ''}';

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _btnCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));

    _sheetAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic);
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final screenH = MediaQuery.of(context).size.height;
    final cardColor = Theme.of(context).cardTheme.color;
    final textColor = context.appColors.textPrimary;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(_sheetAnim),
      child: FadeTransition(
        opacity: _sheetAnim,
        child: Container(
          constraints: BoxConstraints(maxHeight: screenH * 0.88),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                ),
              ),

              // ── Scrollable Body ──────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Hero Image ────────────────────────
                        _HeroImage(imageUrl: _imageUrl),

                        // ── Info Block ────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category pill
                              if ((widget.item.catDescEn ?? '').isNotEmpty) ...[
                                _CategoryPill(label: widget.item.catDescEn!),
                                const SizedBox(height: 10),
                              ],

                              // Name
                              Text(
                                widget.item.itemDesc ?? '',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textColor, height: 1.25, letterSpacing: -0.5),
                              ),
                              const SizedBox(height: 6),

                              // Code
                              Row(
                                children: [
                                  Icon(Icons.qr_code_rounded, size: 12, color: textColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.item.itemCode ?? '—',
                                    style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              const _Divider(),
                              const SizedBox(height: 18),

                              // ── Price Row ────────────────────
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${widget.item.itemPrice1?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: _pink, letterSpacing: -1),
                                  ),
                                  const SizedBox(width: 8),

                                  const Spacer(),
                                  _StatusBadge(available: (widget.item.itemStat ?? 'A') == 'A'),
                                ],
                              ),

                              const SizedBox(height: 20),
                              const _Divider(),
                              const SizedBox(height: 18),

                              // ── Detail Chips Row ─────────────
                              _DetailRow(item: widget.item),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
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
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final String imageUrl;
  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              frameBuilder: (_, child, frame, sync) {
                if (sync) return child;
                return AnimatedOpacity(opacity: frame == null ? 0 : 1, duration: const Duration(milliseconds: 300), child: child);
              },
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFF5F5F7),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: const Color(0xFFE8316A),
                      value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
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
                      Icon(Icons.restaurant_rounded, size: 52, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('No Image', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                    ],
                  ),
                ),
              ),
            ),
            // Subtle bottom fade so content flows naturally
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white.withOpacity(0.15)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  const _CategoryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFFECF2), borderRadius: BorderRadius.circular(20)),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(color: Color(0xFFE8316A), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool available;
  const _StatusBadge({required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: available ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7, color: available ? Colors.green.shade600 : Colors.red.shade400),
          const SizedBox(width: 5),
          Text(
            available ? 'Available' : 'Unavailable',
            style: TextStyle(fontSize: 11, color: available ? Colors.green.shade700 : Colors.red.shade500, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFF0F0F2));
  }
}

class _DetailRow extends StatelessWidget {
  final MenuModel item;
  const _DetailRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final chips = <_ChipData>[
      if ((item.catDescEn ?? '').isNotEmpty) _ChipData(Icons.category_rounded, 'Category', item.catDescEn!),
      if (item.itemPrice2 != null && item.itemPrice2! > 0) _ChipData(Icons.sell_rounded, 'Price 2', '\$${item.itemPrice2!.toStringAsFixed(2)}'),
      if ((item.itemType ?? '').isNotEmpty) _ChipData(Icons.inventory_2_rounded, 'Type', item.itemType!),
    ];

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 10, runSpacing: 10, children: chips.map((c) => _InfoChip(data: c)).toList());
  }
}

class _ChipData {
  final IconData icon;
  final String label;
  final String value;
  const _ChipData(this.icon, this.label, this.value);
}

class _InfoChip extends StatelessWidget {
  final _ChipData data;
  const _InfoChip({required this.data});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color;
    final textColor = context.appColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEF2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 14, color: textColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                style: TextStyle(fontSize: 9, color: textColor, fontWeight: FontWeight.w700, letterSpacing: 0.4),
              ),
              const SizedBox(height: 1),
              Text(
                data.value,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final int qty;
  final double total;
  final double bottomInset;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAdd;
  final Animation<double> btnScale;

  const _StickyFooter({
    required this.qty,
    required this.total,
    required this.bottomInset,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAdd,
    required this.btnScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1.5)),
      ),
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset + 14),
      child: Row(
        children: [
          // ── Qty Selector ──
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF5F5F7), borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                _QtyBtn(icon: Icons.remove_rounded, onTap: qty > 1 ? onDecrease : null),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$qty',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF1A1D2E)),
                  ),
                ),
                _QtyBtn(icon: Icons.add_rounded, onTap: qty < 99 ? onIncrease : null),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 46,
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: active ? const Color(0xFF1A1D2E) : Colors.grey.shade300),
      ),
    );
  }
}
