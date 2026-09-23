import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable cached network image with shimmer-like placeholder and error fallback
class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = imageUrl.isEmpty
        ? _buildErrorWidget()
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) =>
                placeholder ?? _buildDefaultPlaceholder(),
            errorWidget: (context, url, error) =>
                errorWidget ?? _buildErrorWidget(),
          );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.white.withValues(alpha: 0.08),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white38),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.black.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: Colors.white.withValues(alpha: 0.4),
          size: 28,
        ),
      ),
    );
  }
}
