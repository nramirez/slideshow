import 'package:flutter/material.dart';
import 'package:slideshow/slideshow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SlideShow Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final demoImageLinks = <String>[
    'https://unsplash.com/photos/lnyzp2RzRNk/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjc5NzU5NDk0&force=true&w=1920',
    'https://unsplash.com/photos/g6aiOWGoc5s/download?ixid=MnwxMjA3fDB8MXxhbGx8MzR8fHx8fHwyfHwxNjc5NzU4Mjgw&force=true&w=1920',
    'https://unsplash.com/photos/WNfyfN1To5g/download?ixid=MnwxMjA3fDB8MXx0b3BpY3x8Ym84alFLVGFFMFl8fHx8fDJ8fDE2Nzk3NTM1OTM&force=true&w=1920',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Launch Slideshow'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SlideShow(
                    urls: demoImageLinks,
                  ),
                ),
              );
            },
            child: const Text('Launch Slideshow'),
          ),
        ));
  }
}
