import 'package:area_selector/multi_area_selector.dart';
import 'package:flutter/material.dart';
import 'package:area_selector/area_selector.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(child: SelectorDemo()),
      ),
    );
  }
}

class SelectorDemo extends StatefulWidget {
  const SelectorDemo({Key? key}) : super(key: key);
  @override
  State<SelectorDemo> createState() => _SelectorDemoState();
}

class _SelectorDemoState extends State<SelectorDemo> {
  Rect selection = const Rect.fromLTWH(50, 100, 200, 150);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/sample.jpg', fit: BoxFit.cover),
        ),
        AreaSelector(
          initialRect: selection,
          aspectRatio: 10,
          gridSize: 20,
          borderColor: Colors.red,
          onChanged: (newRect) {
            setState(() => selection = newRect);
          },
        ),
        MultiAreaSelector(
          initialRects: const [
            Rect.fromLTWH(40, 40, 120, 100),
            Rect.fromLTWH(200, 150, 160, 120),
          ],
          gridSize: 30,
          aspectRatio: 15,
          borderColor: Colors.green,
          onChanged: (rects) => ("anything does"), //print('Updated regions: $rects'),
        ),
      ],
    );
  }
}
