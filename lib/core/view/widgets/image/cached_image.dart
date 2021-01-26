import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FlightCachedImage extends StatelessWidget {
  final String imageUrl;

  const FlightCachedImage({Key key, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
    );
  }
}
