import 'package:area_selector/multi_area_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:area_selector/area_selector.dart';

void main() {
  testWidgets('AreaSelector renders at the correct initial position', (tester) async {
    const initialRect = Rect.fromLTWH(20, 30, 100, 80);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              AreaSelector(
                initialRect: initialRect,
                aspectRatio: 10,
                gridSize: 20,
                borderColor: Colors.red,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    final container = find.byType(Container).first;
    expect(container, findsWidgets);

    final positioned = tester.widget<Positioned>(
      find.ancestor(of: container, matching: find.byType(Positioned)).first,
    );

    expect(positioned.left, initialRect.left);
    expect(positioned.top, initialRect.top);
    expect(positioned.width, initialRect.width);
    expect(positioned.height, initialRect.height);
  });

  testWidgets('AreaSelector can be dragged to a new position', (tester) async {
    Rect updatedRect = Rect.zero;

    const initialRect = Rect.fromLTWH(0, 0, 100, 80);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              AreaSelector(
                initialRect: initialRect,
                onChanged: (rect) => updatedRect = rect,
              ),
            ],
          ),
        ),
      ),
    );

    final dragTarget = find.byType(Container).first;

    await tester.drag(dragTarget, const Offset(20, 30));
    await tester.pump();

    expect(updatedRect.left, initialRect.left + 20);
    expect(updatedRect.top, initialRect.top + 30);
  });

  testWidgets('MultiAreaSelector renders multiple regions at correct initial positions', (tester) async {
    const rect1 = Rect.fromLTWH(20, 30, 100, 80);
    const rect2 = Rect.fromLTWH(120, 130, 150, 120);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiAreaSelector(
            initialRects: const [
              rect1,
              rect2
            ],
            gridSize: 30,
            aspectRatio: 2.0,
            borderColor: Colors.green,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final positionedRects = tester.widgetList<Positioned>(find.byType(Positioned)).toList();
    final mainRects = positionedRects.where((p) => p.width! > 50 && p.height! > 50).toList();

    expect(mainRects.length, 2);

    expect(mainRects[0].left, rect1.left);
    expect(mainRects[0].top, rect1.top);
    expect(mainRects[0].width, rect1.width);
    expect(mainRects[0].height, rect1.height);

    expect(mainRects[1].left, rect2.left);
    expect(mainRects[1].top, rect2.top);
    expect(mainRects[1].width, rect2.width);
    expect(mainRects[1].height, rect2.height);
  });

  testWidgets('MultiAreaSelector calls onChanged with updated rects on drag', (tester) async {
    const rect1 = Rect.fromLTWH(0, 0, 100, 80);
    const rect2 = Rect.fromLTWH(50, 50, 120, 90);

    List<List<Rect>> callbackValues = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiAreaSelector(
            initialRects: const [
              rect1,
              rect2
            ],
            gridSize: 0, // disable snapping for simpler behavior
            aspectRatio: null, // disable aspect lock
            borderColor: Colors.green,
            onChanged: (newRects) {
              callbackValues.add(newRects);
            },
          ),
        ),
      ),
    );

    final firstRegion = find.descendant(
      of: find.byType(AreaSelector).at(0),
      matching: find.byType(Container),
    ).first;

    await tester.drag(firstRegion, const Offset(20, 30));
    await tester.pump();

    expect(callbackValues.isNotEmpty, true);
    
    final lastRects = callbackValues.last;
    expect(lastRects.length, 2);
    expect(lastRects[0].left, rect1.left + 20);
    expect(lastRects[0].top, rect1.top + 30);
    
    // The second rect should remain unchanged
    expect(lastRects[1].left, rect2.left);
    expect(lastRects[1].top, rect2.top);
  });
}
