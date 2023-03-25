library flutter_slideshow;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slideshow/img_card.dart';
import 'package:flutter_slideshow/ticker.dart';

/// SlideShow for displaying a list of images
/// relies on [ImgCard] for displaying the images
/// [urls] is the list of urls to display
/// [autoPlayTimeInSeconds] is the time between switching images
/// [maxAutoPlayTimeInSeconds] is the maximum time between switching images
/// [hideControlsAfterSeconds] is the time after which the controls are hidden
/// [isFavorite] function which checks whether a url is a favorite
/// [toggleFavorite] function which toggles the favorite status of a url
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

  /// The list of urls to display
  final List<String> urls;

  /// The time between switching images
  final int autoPlayTimeInSeconds;

  /// The maximum time between switching images
  final int maxAutoPlayTimeInSeconds;

  /// The time after which the controls are hidden
  final int hideControlsAfterSeconds;

  /// Function which checks whether a url is a favorite
  final bool Function(String url)? isFavorite;

  /// Function which toggles the favorite status of a url
  final void Function(String url)? toggleFavorite;

  @override
  State<SlideShow> createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  /// The controller for the pageview
  final controller = PageController();

  /// Whether the controls are hidden
  bool hideControls = false;

  /// Keep track of the last interaction
  DateTime mostRecentInteraction = DateTime.now();

  /// The time between switching images
  late int autoPlayTimeInSeconds;

  /// The maximum time between switching images
  late int maxAutoPlayTimeInSeconds;

  /// The time after which the controls are hidden
  late int hideControlsAfterSeconds;

  /// Ticker subscription used to avoid memory leaks
  StreamSubscription<int>? tickerSubscription;

  @override
  void initState() {
    super.initState();

    /// Set the initial values from the widget params
    autoPlayTimeInSeconds = widget.autoPlayTimeInSeconds;
    maxAutoPlayTimeInSeconds = widget.maxAutoPlayTimeInSeconds;
    hideControlsAfterSeconds = widget.hideControlsAfterSeconds;

    /// Listen to the pageview controller
    tickerSubscription = SlideShowTicker.tick().listen((event) {
      /// Change page every [autoPlayTimeInSeconds] seconds
      /// Skip the the very first event to avoid changing page on init
      if (event % autoPlayTimeInSeconds == 0 && event > 0) {
        controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

      /// Hide the controls after [hideControlsAfterSeconds] seconds
      if (DateTime.now().difference(mostRecentInteraction).inSeconds >
          hideControlsAfterSeconds) {
        setState(() {
          hideControls = true;
        });
      }
    });
  }

  @override
  void dispose() {
    /// Avoid memory leaks by disposing page controller and ticker subscription
    controller.dispose();
    tickerSubscription?.cancel();
    super.dispose();
  }

  /// SlideShow controls
  /// [go-left] button to go to the previous image
  /// [go-right] button to go to the next image
  /// [close] button to close the slideshow
  /// [slider] to change the time between switching images
  List<Widget> controls() {
    /// The controls are only visible when the user interacts with the screen
    final opacity = hideControls ? 0.0 : 1.0;

    /// The controls fade in and out
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
    return GestureDetector(
      onTap: () {
        /// Update the last interaction time
        mostRecentInteraction = DateTime.now();

        /// Show the controls
        setState(() {
          hideControls = false;
        });
      },
      child: Scaffold(
        body: Stack(
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
