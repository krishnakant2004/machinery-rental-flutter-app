import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/constants.dart';

class CustomNetworkImage extends StatelessWidget {
  String imageUrl;
  final BoxFit fit;
  final double scale;
  final double? width;
  final double? height;

  CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.scale = 1.0,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    String url = imageUrl.replaceAll("localhost",kImageUrlChangeIp);

    if (kDebugMode) {
      print(imageUrl);
    }
    return Image.network(
      url,
      fit: fit,
      scale: scale,
      width: width,
      height: height,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Center(
          child: Image.asset(
            "assets/images/placeholder.jpg",
            width: width,
            height: height,
            fit: fit,
          ),
        );
      },
    );
  }
}
