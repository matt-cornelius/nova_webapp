import 'package:flutter/material.dart';

/// Helper widget that loads organization logo images from either assets or network.
///
/// This widget automatically detects whether the imageUrl is a local asset
/// (starts with 'assets/') or a network URL (starts with 'http://' or 'https://')
/// and uses the appropriate Flutter Image widget.
///
/// Usage:
/// ```dart
/// OrganizationImage(
///   imageUrl: organization.logoUrl,
///   width: 120,
///   height: 120,
///   fit: BoxFit.cover,
/// )
/// ```
class OrganizationImage extends StatelessWidget {
  /// The URL or asset path to the image.
  /// If it starts with 'assets/', it will be loaded as an asset.
  /// Otherwise, it will be loaded from the network.
  final String imageUrl;

  /// Width of the image widget.
  final double? width;

  /// Height of the image widget.
  final double? height;

  /// How the image should be fitted within its bounds.
  final BoxFit fit;

  /// Widget to show if the image fails to load.
  /// If null, a default error widget with an icon will be shown.
  final Widget? errorWidget;

  /// Border radius for the image (applied via ClipRRect).
  /// If null, no clipping is applied.
  final BorderRadius? borderRadius;

  const OrganizationImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.borderRadius,
  });

  /// Determines if the imageUrl is a local asset path.
  /// Asset paths in Flutter typically start with 'assets/'.
  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    // Get theme colors for error widget fallback
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Default error widget - shows a business icon in a colored container
    final Widget defaultErrorWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.business,
        size: (width != null && height != null)
            ? (width! < height! ? width! * 0.5 : height! * 0.5)
            : 30,
        color: colors.onPrimaryContainer,
      ),
    );

    // Create the image widget based on whether it's an asset or network URL
    final Widget imageWidget = _isAsset
        ? Image.asset(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              // Return custom error widget or default
              return errorWidget ?? defaultErrorWidget;
            },
          )
        : Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              // Return custom error widget or default
              return errorWidget ?? defaultErrorWidget;
            },
          );

    // Apply border radius if specified
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

