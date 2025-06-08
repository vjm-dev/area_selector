import 'package:flutter/material.dart';

import 'area_selector.dart';

class MultiAreaSelector extends StatefulWidget {
  final List<Rect> initialRects;
  final ValueChanged<List<Rect>>? onChanged;
  final double? aspectRatio;
  final double? gridSize;
  final double handleSize;
  final Color borderColor;

  const MultiAreaSelector({
    Key? key,
    required this.initialRects,
    this.onChanged,
    this.aspectRatio,
    this.gridSize,
    this.handleSize = 16.0,
    this.borderColor = Colors.blue,
  }) : super(key: key);

  @override
  State<MultiAreaSelector> createState() => _MultiAreaSelectorState();
}

class _MultiAreaSelectorState extends State<MultiAreaSelector> {
  late List<Rect> rects;

  @override
  void initState() {
    super.initState();
    rects = List.from(widget.initialRects);
  }

  void _updateRect(int index, Rect newRect) {
    setState(() {
      rects[index] = newRect;
      widget.onChanged?.call(List.unmodifiable(rects));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < rects.length; i++)
          AreaSelector(
            key: ValueKey('selector_$i'),
            initialRect: rects[i],
            aspectRatio: widget.aspectRatio,
            gridSize: widget.gridSize,
            handleSize: widget.handleSize,
            borderColor: widget.borderColor,
            onChanged: (r) => _updateRect(i, r),
          ),
      ],
    );
  }
}

