import 'package:flutter/foundation.dart';
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
  late List<int> _order;

  @override
  void initState() {
    super.initState();
    rects = List.from(widget.initialRects);
    _order = List.generate(rects.length, (i) => i);
  }

  @override
  void didUpdateWidget(MultiAreaSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.initialRects, oldWidget.initialRects)) {
      setState(() {
        rects = List.from(widget.initialRects);
        if (rects.length != _order.length) {
          _order = List.generate(rects.length, (i) => i);
        }
      });
    }
  }

  void _updateRect(int index, Rect newRect) {
    setState(() {
      rects[index] = newRect;
      widget.onChanged?.call(List.unmodifiable(rects));
    });
  }

  void _bringToFront(int index) {
    setState(() {
      _order.remove(index);
      _order.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < _order.length; i++)
          AreaSelector(
            key: ValueKey(_order[i]),
            initialRect: rects[_order[i]],
            aspectRatio: widget.aspectRatio,
            gridSize: widget.gridSize,
            handleSize: widget.handleSize,
            borderColor: widget.borderColor,
            onChanged: (r) => _updateRect(_order[i], r),
            onDragStart: () {
              if (_order.last != _order[i]) {
                _bringToFront(_order[i]);
              }
            },
            onDragEnd: () => widget.onChanged?.call(List.unmodifiable(rects)),
          ),
      ],
    );
  }
}

