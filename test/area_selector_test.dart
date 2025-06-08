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
}
