import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';

class TeamBadge extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? tag;

  const TeamBadge({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (imageUrl == null || imageUrl!.isEmpty) {
      image = _placeholder();
    } else if (imageUrl!.toLowerCase().endsWith('.svg')) {
      image = SvgPicture.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => _placeholder(),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _placeholder(),
      );
    }

    final decoratedImage = Container(
      width: size * 1.3, // Hacerlo ligeramente más ancho para mantener la proporción rectangular de las banderas
      height: size * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightGray.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: image,
    );

    if (tag != null) {
      return Hero(tag: tag!, child: decoratedImage);
    }
    return decoratedImage;
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.shield,
        color: Colors.grey.shade500,
        size: size * 0.5,
      ),
    );
  }
}
