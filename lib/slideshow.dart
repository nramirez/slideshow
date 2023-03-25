library flutter_slideshow;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slideshow/img_card.dart';
import 'package:flutter_slideshow/ticker.dart';

class SlideShow extends StatefulWidget {
  const SlideShow({
    required this.urls,
    this.autoPlayTimeInSeconds = 30,
    this.maxAutoPlayTimeInSeconds = 300,
    this.hideControlsAfterSeconds = 15,
    this.isFavorite,
    this.toggleFavorite,
    super.key,
  });

  final List<String> urls;
  final int autoPlayTimeInSeconds;
  final int maxAutoPlayTimeInSeconds;
  final int hideControlsAfterSeconds;
  final bool Function(String url)? isFavorite;
  final void Function(String url)? toggleFavorite;

  @override
  State<SlideShow> createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  final controller = PageController();
  bool hideControls = false;
  DateTime lastInteractionTime = DateTime.now();
  late int autoPlayTimeInSeconds;
  late int maxAutoPlayTimeInSeconds;
  late int hideControlsAfterSeconds;

  StreamSubscription<int>? tickerSubscription;

  @override
  void initState() {
    super.initState();
    autoPlayTimeInSeconds = widget.autoPlayTimeInSeconds;
    maxAutoPlayTimeInSeconds = widget.maxAutoPlayTimeInSeconds;
    hideControlsAfterSeconds = widget.hideControlsAfterSeconds;
    tickerSubscription = SlideShowTicker.tick().listen((event) {
      if (event % autoPlayTimeInSeconds == 0 && event > 0) {
        controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      if (DateTime.now().difference(lastInteractionTime).inSeconds >
          hideControlsAfterSeconds) {
        setState(() {
          hideControls = true;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    tickerSubscription?.cancel();
    super.dispose();
  }

  List<Widget> controls() {
    final opacity = hideControls ? 0.0 : 1.0;
    const duration = Duration(seconds: 1);

    return [
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: duration,
          child: FloatingActionButton(
            heroTag: 'go-left',
            backgroundColor: Colors.black.withOpacity(0.3),
            onPressed: () {
              controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
      ),
      Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: duration,
          child: FloatingActionButton(
            heroTag: 'go-right',
            backgroundColor: Colors.black.withOpacity(0.3),
            onPressed: () {
              controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: duration,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      Positioned(
        top: 30,
        right: MediaQuery.of(context).size.width / 2 - 100,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: duration,
          child: Slider(
            divisions: 60,
            label: '${autoPlayTimeInSeconds}s',
            value: autoPlayTimeInSeconds.toDouble() / maxAutoPlayTimeInSeconds,
            onChanged: (value) {
              setState(() {
                autoPlayTimeInSeconds =
                    (value * maxAutoPlayTimeInSeconds).toInt();
              });
            },
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            hideControls = false;
            lastInteractionTime = DateTime.now();
          });
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: widget.urls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: ImgCard(
                    imgUrl: widget.urls[index],
                    isFavorite: widget.isFavorite,
                    toggleFavorite: widget.toggleFavorite,
                  ),
                );
              },
            ),
            ...controls(),
          ],
        ),
      ),
    );
  }
}
