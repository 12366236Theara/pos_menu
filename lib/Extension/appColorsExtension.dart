import 'dart:ui';

import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color card;
  final Color surface;
  final Color header;
  final Color border;
  final Color chipBg;
  final Color chipBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;

  const AppColorsExtension({
    required this.card,
    required this.surface,
    required this.header,
    required this.border,
    required this.chipBg,
    required this.chipBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
  });

  // ── Presets ───────────────────────────────────────────────────────────────
  static const light = AppColorsExtension(
    card: Colors.white,
    surface: Color(0xFFF2F2F7),
    header: Colors.white,
    border: Color(0xFFE5E5EA),
    chipBg: Colors.white,
    chipBorder: Color(0xFFD1D1D6),
    textPrimary: Color(0xFF1A1D2E),
    textSecondary: Color(0xFF8E8E93),
    textHint: Color(0xFFAEAEB2),
  );

  static const dark = AppColorsExtension(
    card: Color(0xFF1C1F2E),
    surface: Color(0xFF252837),
    header: Color(0xFF1C1F2E),
    border: Color(0xFF2E3147),
    chipBg: Color(0xFF252837),
    chipBorder: Color(0xFF3A3D52),
    textPrimary: Color(0xFFF0F0F5),
    textSecondary: Color(0xFF9094A8),
    textHint: Color(0xFF6B6F82),
  );

  @override
  AppColorsExtension copyWith({
    Color? card,
    Color? surface,
    Color? header,
    Color? border,
    Color? chipBg,
    Color? chipBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
  }) {
    return AppColorsExtension(
      card: card ?? this.card,
      surface: surface ?? this.surface,
      header: header ?? this.header,
      border: border ?? this.border,
      chipBg: chipBg ?? this.chipBg,
      chipBorder: chipBorder ?? this.chipBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      card: Color.lerp(card, other.card, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      header: Color.lerp(header, other.header, t)!,
      border: Color.lerp(border, other.border, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
    );
  }
}

// ── Convenience extension so you can write: context.appColors.card ──────────
extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors => Theme.of(this).extension<AppColorsExtension>()!;
}
