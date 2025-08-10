import 'package:flutter/material.dart';

class AreaSelector extends StatefulWidget {
  final Rect initialRect;
  final void Function(Rect)? onChanged;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;
  final double? aspectRatio;
  final double? gridSize;
  final double handleSize;
  final Color borderColor;

  const AreaSelector({
    Key? key,
    required this.initialRect,
    this.onChanged,
    this.onDragStart,
    this.onDragEnd,
    this.aspectRatio,
    this.gridSize,
    this.handleSize = 16.0,
    this.borderColor = Colors.blue,
  }) : super(key: key);

  @override
  State<AreaSelector> createState() => _AreaSelectorState();
}

class _AreaSelectorState extends State<AreaSelector> {
  late Rect rect;
  DragHandle? activeHandle;
  Offset? dragStart;

  @override
  void initState() {
    super.initState();
    rect = widget.initialRect;
  }

  @override
  void didUpdateWidget(AreaSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRect != oldWidget.initialRect) {
      rect = widget.initialRect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fromRect(
          rect: rect,
          child: GestureDetector(
            onPanStart: _onDragStart,
            onPanUpdate: _onDragUpdate,
            onPanEnd: (_) => _endDrag(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: widget.borderColor, width: 2),
              ),
            ),
          ),
        ),
        ..._buildHandles(),
      ],
    );
  }

  List<Widget> _buildHandles() {
    final hs = widget.handleSize;
    final handles = <_HandlePos, Offset>{
      _HandlePos.topLeft: rect.topLeft,
      _HandlePos.topRight: Offset(rect.right, rect.top),
      _HandlePos.bottomLeft: Offset(rect.left, rect.bottom),
      _HandlePos.bottomRight: rect.bottomRight,
    };
    return handles.entries.map((e) {
      return Positioned(
        left: e.value.dx - hs / 2,
        top: e.value.dy - hs / 2,
        width: hs,
        height: hs,
        child: GestureDetector(
          onPanStart: (_) {
            activeHandle = _handleFromPosition(e.key);
            dragStart = e.value;
            widget.onDragStart?.call();
          },
          onPanUpdate: (d) {
            _resize(e.key, d.delta);
            widget.onChanged?.call(rect);
          },
          onPanEnd: (_) => _endDrag(),
          child: Container(
            decoration: BoxDecoration(
              color: widget.borderColor,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _onDragStart(DragStartDetails details) {
    activeHandle = DragHandle.move;
    dragStart = details.globalPosition;
    widget.onDragStart?.call();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (activeHandle == DragHandle.move) {
      setState(() {
        final newTopLeft = rect.topLeft + details.delta;
        final newLeft = _snap(newTopLeft.dx);
        final newTop = _snap(newTopLeft.dy);

        rect = Rect.fromLTWH(
          newLeft,
          newTop,
          rect.width,
          rect.height,
        );
        widget.onChanged?.call(rect);
      });
    }
  }

  double _snap(double value) {
    final g = widget.gridSize;
    if (g == null || g <= 0) return value;
    return (value / g).round() * g;
  }

  void _resize(_HandlePos pos, Offset delta) {
    setState(() {
      double left = rect.left;
      double top = rect.top;
      double right = rect.right;
      double bottom = rect.bottom;

      switch (pos) {
        case _HandlePos.topLeft:
          left = (left + delta.dx).clamp(0, right - 1);
          top = (top + delta.dy).clamp(0, bottom - 1);
          if (widget.aspectRatio != null) {
            final width = right - left;
            final height = width / widget.aspectRatio!;
            top = bottom - height;
          }
          break;
        case _HandlePos.topRight:
          right = (right + delta.dx).clamp(left + 1, double.infinity);
          top = (top + delta.dy).clamp(0, bottom - 1);
          if (widget.aspectRatio != null) {
            final width = right - left;
            final height = width / widget.aspectRatio!;
            top = bottom - height;
          }
          break;
        case _HandlePos.bottomLeft:
          left = (left + delta.dx).clamp(0, right - 1);
          bottom = (bottom + delta.dy).clamp(top + 1, double.infinity);
          if (widget.aspectRatio != null) {
            final width = right - left;
            final height = width / widget.aspectRatio!;
            bottom = top + height;
          }
          break;
        case _HandlePos.bottomRight:
          right = (right + delta.dx).clamp(left + 1, double.infinity);
          bottom = (bottom + delta.dy).clamp(top + 1, double.infinity);
          if (widget.aspectRatio != null) {
            final width = right - left;
            final height = width / widget.aspectRatio!;
            bottom = top + height;
          }
          break;
      }

      // Snap an make sure the rectangle is valid
      rect = Rect.fromLTRB(
        _snap(left),
        _snap(top),
        _snap(right),
        _snap(bottom),
      );
    });
  }

  void _endDrag() {
    activeHandle = null;
    dragStart = null;
    widget.onDragEnd?.call();
  }
}

enum DragHandle { move, topLeft, topRight, bottomLeft, bottomRight }
enum _HandlePos { topLeft, topRight, bottomLeft, bottomRight }

DragHandle _handleFromPosition(_HandlePos pos) {
  switch (pos) {
    case _HandlePos.topLeft: return DragHandle.topLeft;
    case _HandlePos.topRight: return DragHandle.topRight;
    case _HandlePos.bottomLeft: return DragHandle.bottomLeft;
    case _HandlePos.bottomRight: return DragHandle.bottomRight;
  }
}