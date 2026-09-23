import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imageUrl;
  final Widget child;
  final double opacity;

  const BackgroundImage({
    super.key,
    required this.imageUrl,
    required this.child,
    this.opacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: opacity),
            BlendMode.darken,
          ),
        ),
      ),
      child: child,
    );
  }
}
