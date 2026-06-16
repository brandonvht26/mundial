import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        placeholderBuilder: (_) => _placeholder(),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _placeholder(),
      );
    }

    if (tag != null) {
      return Hero(tag: tag!, child: image);
    }
    return image;
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
