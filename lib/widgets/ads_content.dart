import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/ads_provider.dart';

class AdsContent extends StatelessWidget {

  final Function() press;

  const AdsContent({Key? key, required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<AdsProvider>(context);

    return provider.item != null ?  GestureDetector(
      onTap: press,
      child:  provider.item!.image != null ? AspectRatio(
        aspectRatio: 2.3,
        child: CachedNetworkImage(
          imageUrl: provider.item!.image!,
          fit: BoxFit.cover,
        ),
      ): SizedBox.shrink(),
    ) : const SizedBox.shrink();
  }
}