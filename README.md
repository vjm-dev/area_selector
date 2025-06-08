# area_selector

**`area_selector`** is a Flutter widget package that allows users to select, move, and resize rectangular areas interactively. Ideal for cropping tools, design editors, annotations, games, or any UI where the user needs to mark a region on screen.

---

## Features

- Tap and drag to move a rectangular area.
- Resize the area from any of the four corner handles.
- Optional aspect ratio locking.
- Snap-to-grid support.
- Support for multiple regions (multi-area selection).
- Customizable handle size and border color.
- Realtime updates via callback (`onChanged`) with the current `Rect`.
- Lightweight and dependency-free.

---

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  area_selector:
```

Then run:
```bash
flutter pub get
```

---

## Usage

- Single Area Example:
```dart
import 'package:area_selector/area_selector.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your background content here

        AreaSelector(
          initialRect: Rect.fromLTWH(50, 50, 150, 150),
          aspectRatio: 1.0,
          gridSize: 20,
          onChanged: (rect) {
            print('Updated region: $rect');
          },
        ),
      ],
    );
  }
}
```

- Multi-Area Example:
```dart
import 'package:area_selector/multi-area_selector.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your background content here

        MultiAreaSelector(
          initialRects: [
            Rect.fromLTWH(40, 40, 120, 100),
            Rect.fromLTWH(200, 150, 160, 120),
          ],
          aspectRatio: 4 / 3,
          gridSize: 16,
          onChanged: (rects) {
            print('All regions: $rects');
          },
        ),
      ],
    );
  }
}
```

---

## Constructor parameters

- `AreaSelector`:

| Parameter     | Type             | Description                        |
| ------------- | ---------------- | ---------------------------------- |
| `initialRect` | `Rect`           | Starting position and size         |
| `onChanged`   | `Function(Rect)` | Callback when area changes         |
| `aspectRatio` | `double?`        | Optional fixed width/height ratio  |
| `gridSize`    | `double?`        | Optional grid snapping (e.g. 20.0) |
| `handleSize`  | `double`         | Size of draggable corners          |
| `borderColor` | `Color`          | Border and handle color            |

- `MultiAreaSelector`:

Same as `AreaSelector`, but operates on a `List<Rect>` via `initialRects` and `onChanged(List<Rect>)`.

---

## Running demo example

You can find a complete demo in the [/example](example/) directory. To run it:

```bash
flutter run --example
```
