import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';

class NetworkImageview extends StatelessWidget {
  final String imagePath; // relative path from API
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color backgroundColor;

  const NetworkImageview({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFE0E0E0),
  });

  String get _fullUrl => '${Domain.domain}/$imagePath';

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _errorWidget();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: _fullUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _loadingWidget(),
        errorWidget: (context, url, error) => _errorWidget(),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _errorWidget() {
    return Container(width: width, height: height, color: backgroundColor, alignment: Alignment.center, child: Image.asset('assets/noimage.png'));
  }
}
