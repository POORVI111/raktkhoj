/*
show images from the internet and keep them in the cache directory.
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:raktkhoj/colors.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;
  final BoxFit fit;



  CachedImage(
      this.imageUrl, {
        this.isRound = false,
        this.radius = 0,
        this.height,
        this.width,
        this.fit = BoxFit.cover,
      });

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(isRound ? 50 : radius),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 45.0,
                backgroundImage: AssetImage('images/logo.png'),
                backgroundColor: kBackgroundColor,
              ),
            )),
      );
    } catch (e) {
      print(e);
      return CircleAvatar(
        radius: 45.0,
        backgroundImage: AssetImage('images/logo.png'),
        backgroundColor: kBackgroundColor,
      );
    }
  }
}