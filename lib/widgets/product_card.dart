import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String image;
  final Color backgroundColor;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2, // Added to handle longer product names
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            '\$$price',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Center(
            child: _buildImageWidget(), // Modified this line
          ),
        ],
      ),
    );
  }

  // New helper method to handle both network and asset images
  Widget _buildImageWidget() {
    // Check if image is a network URL (from API)
    if (image.startsWith('http')) {
      return Image.network(
        image,
        height: 175,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: 175,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported, size: 50);
        },
      );
    } 
    // Fallback for local assets (if you keep any)
    else {
      return Image.asset(
        image,
        height: 175,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported, size: 50);
        },
      );
    }
  }
}