import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/utils/app_colors.dart';

class CacheImage extends StatelessWidget {
  final String link;
  final String name;
  final double radius;
  final double height;
  final double width;

  CacheImage(
      {Key? key, required this.link, required this.name, required this.radius,this.height = 40, this.width = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height,
      height: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: link,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: AppColors.primary),
                child: Center(
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
          errorWidget: (context, url, dynamic error) => Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: AppColors.primary),
            child: Center(
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
