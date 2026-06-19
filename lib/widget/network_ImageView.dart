import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';

class NetworkImageview extends StatelessWidget {
  final String imagePath;
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
      child: Image.network(_fullUrl, width: width, height: height, fit: fit),
    );

    // return ClipRRect(
    //   borderRadius: borderRadius ?? BorderRadius.circular(12),
    //   child: CachedNetworkImage(
    //     imageUrl: _fullUrl,
    //     width: width,
    //     height: height,
    //     fit: fit,

    //     // ✅ smoother UX on web
    //     fadeInDuration: const Duration(milliseconds: 200),
    //     fadeOutDuration: const Duration(milliseconds: 100),

    //     placeholder: (context, url) => _loadingWidget(),
    //     errorWidget: (context, url, error) => _errorWidget(),
    //   ),
    // );
  }

  Widget _loadingWidget() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      alignment: Alignment.center,
      child: const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE8316A))),
    );
  }

  Widget _errorWidget() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Image.asset('assets/noimage.png', fit: BoxFit.contain),
    );
  }
}
