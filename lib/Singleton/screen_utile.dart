enum ScreenType { mobile, tablet, desktop }

ScreenType getScreenType(double width) {
  if (width >= 900) return ScreenType.desktop;
  if (width >= 600) return ScreenType.tablet;
  return ScreenType.mobile;
}
