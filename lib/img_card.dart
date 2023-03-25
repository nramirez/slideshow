import 'dart:io';

import 'package:bg/bg.dart';
import 'package:bg/options.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ImgCard extends StatelessWidget {
  const ImgCard({
    required this.imgUrl,
    this.description,
    this.isFavorite,
    this.toggleFavorite,
    super.key,
  });
  final String imgUrl;
  final String? description;
  final void Function(String)? toggleFavorite;
  final bool Function(String)? isFavorite;

  Future<void> share(BuildContext context) async {
    final byteData = await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl);
    final bytes = byteData.buffer.asUint8List();
    final name = imgUrl.split('/').last;
    // ignore: use_build_context_synchronously
    final box = context.findRenderObject() as RenderBox?;

    final file = XFile.fromData(bytes, name: name, mimeType: 'image/png');
    await Share.shareXFiles(
      [file],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<void> updateWallpaper() async {
    await Bg().changeWallpaper(
      options: WallpaperOptions(url: imgUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          CachedNetworkImage(
            cacheKey: imgUrl,
            imageUrl: imgUrl,
            placeholder: (context, url) =>
                const CircularProgressIndicator.adaptive(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              children: [
                // BG only works on macOS
                if (Platform.isMacOS)
                  IconButton(
                    icon: const Icon(Icons.wallpaper),
                    onPressed: () async {
                      await updateWallpaper();
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    await share(context);
                  },
                ),
                if (toggleFavorite != null && isFavorite != null)
                  IconButton(
                    icon: Icon(
                      isFavorite!(imgUrl)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite!(imgUrl) ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      toggleFavorite!(imgUrl);
                    },
                  )
              ],
            ),
          ),
          if (description != null)
            Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  description ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
