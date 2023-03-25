
# Flutter Slideshow

[![pub package](https://img.shields.io/pub/v/flutter_slideshow.svg)](https://pub.dev/packages/flutter_slideshow)

## Features

- Manage interval for the slideshow
- As simple as letting the slideshow know your images
- Share functionality
- Caches image request to improve performance
- Toggle favorite images
- Change wallpaper for MacOS

# How to Use

```dart
Navigator.of(context).push(
    MaterialPageRoute<void>(
        builder: (context) => SlideShow(
            urls: myUrls,
            isFavorite: (url) => stateManager.isFavorite(url),
            toggleFavorite: (url) => stateManager..toggleFavorite(url: url),
            ),
        )
)
```

## Demo

![Example App](https://user-images.githubusercontent.com/1899538/227728628-0ea98843-173f-4262-90e5-d94f2a99f4bb.png)
![Slideshow example](https://user-images.githubusercontent.com/1899538/227728646-c53e2690-0b08-4764-9a48-511bb01f74dd.png)

Youtube demo (Spanish): https://youtu.be/QTxpEGRdFjE


## Maintainers

- [Naz](https://github.com/nramirez)
