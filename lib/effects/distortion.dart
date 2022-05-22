// MIT License
//
// Copyright (c) 2021 Simon Lightfoot
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

final backgroundImageUrl = 'https://images.unsplash.com/photo-1613987549117-13c4781b32d3'
    '?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1024';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final image = NetworkImage(backgroundImageUrl);
  final texture = Completer<ui.Image>();
  image.load(image, PaintingBinding.instance.instantiateImageCodec)
    ..addListener(ImageStreamListener(
          (ImageInfo info, _) => texture.complete(info.image),
      onError: texture.completeError,
    ));

  runApp(ExampleApp(texture: await texture.future));
}

@immutable
class ExampleApp extends StatefulWidget {
  const ExampleApp({
    Key? key,
    required this.texture,
  }) : super(key: key);

  final ui.Image texture;

  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> with SingleTickerProviderStateMixin {
  final _areaKey = GlobalKey();
  final _offsets = ValueNotifier(<Offset>[]);
  var _dir = <Offset>[];
  late AnimationController _controller;

  final radius = 50.0;

  Size get areaSize => (_areaKey.currentContext!.findRenderObject() as RenderBox).size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.addListener(() {
      final size = areaSize;
      final offsets = <Offset>[];
      for (int i = 0; i < _offsets.value.length; i++) {
        var dir = _dir[i];
        var pos = _offsets.value[i] + dir;

        if (pos.dx < radius) {
          pos = Offset(radius, pos.dy);
          dir = Offset(-dir.dx, dir.dy);
        } else if (pos.dx > size.width - radius) {
          pos = Offset(size.width - radius, pos.dy);
          dir = Offset(-dir.dx, dir.dy);
        }
        if (pos.dy < radius) {
          pos = Offset(pos.dx, radius);
          dir = Offset(dir.dx, -dir.dy);
        } else if (pos.dy > size.height - radius) {
          pos = Offset(pos.dx, size.height - radius);
          dir = Offset(dir.dx, -dir.dy);
        }
        _dir[i] = dir;
        offsets.add(pos);
      }
      _offsets.value = offsets;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = areaSize;
      final random = math.Random();
      final count = 5;
      _offsets.value = List.generate(
        count,
            (_) =>
            Offset(
              random.nextDouble() * size.width,
              random.nextDouble() * size.height,
            ),
      );
      _dir = List.generate(
        count,
            (_) =>
            Offset(
              random.nextDouble() * 5.0,
              random.nextDouble() * 5.0,
            ),
      );
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: ClipRect(
          child: AspectRatio(
            key: _areaKey,
            aspectRatio: widget.texture.width / widget.texture.height,
            child: ValueListenableBuilder(
              valueListenable: _offsets,
              builder: (BuildContext context, List<Offset> offsets, Widget? child) {
                return BubbleEffect(
                  texture: widget.texture,
                  offsets: offsets,
                  radius: radius,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleEffect extends LeafRenderObjectWidget {
  const BubbleEffect({
    Key? key,
    required this.texture,
    required this.offsets,
    this.radius = 48.0,
  }) : super(key: key);

  final ui.Image texture;
  final List<Offset> offsets;
  final double radius;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBubbleEffect(
      texture: texture,
      offsets: offsets,
      radius: radius,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderBubbleEffect renderObject) {
    renderObject
      ..texture = texture
      ..offsets = offsets
      ..radius = radius;
  }
}

class RenderBubbleEffect extends RenderBox {
  RenderBubbleEffect({
    required ui.Image texture,
    required List<Offset> offsets,
    required double radius,
  })
      : _offsets = offsets,
        _radius = radius {
    this.texture = texture;
  }

  late List<Offset> _positions;
  late List<Offset> _textureCoords;
  late ImageShader _imageShader;

  ui.Image? _texture;

  ui.Image get texture => _texture!;

  set texture(ui.Image value) {
    if (value != _texture) {
      _texture = value;
      _imageShader = ImageShader(
        texture,
        TileMode.clamp,
        TileMode.clamp,
        Matrix4
            .identity()
            .storage,
      );
      markNeedsPaint();
    }
  }

  late List<Offset> _offsets;

  List<Offset> get offsets => _offsets;

  set offsets(List<Offset> value) {
    if (!listEquals(value, _offsets)) {
      _offsets = value;
      markNeedsPaint();
    }
  }

  late double _radius;

  double get radius => _radius;

  set radius(double value) {
    if (value != _radius) {
      _radius = value;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    final cols = size.width / 24.0;
    final rows = size.height / 24.0;
    final cw = size.width / cols;
    final ch = size.height / rows;
    final tw = texture.width / cols;
    final th = texture.height / rows;

    final positions = <Offset>[];
    final textureCoords = <Offset>[];

    // Create quads for mesh
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        final x0 = col,
            x1 = col + 1;
        final y0 = row,
            y1 = row + 1;
        // Triangle 1
        positions.add(Offset(x0 * cw, y0 * ch));
        positions.add(Offset(x1 * cw, y0 * ch));
        positions.add(Offset(x1 * cw, y1 * ch));
        // UV Coords for Triangle 1
        textureCoords.add(Offset(x0 * tw, y0 * th));
        textureCoords.add(Offset(x1 * tw, y0 * th));
        textureCoords.add(Offset(x1 * tw, y1 * th));
        // Triangle 2
        positions.add(Offset(x1 * cw, y1 * ch));
        positions.add(Offset(x0 * cw, y1 * ch));
        positions.add(Offset(x0 * cw, y0 * ch));
        // UV Coords for Triangle 2
        textureCoords.add(Offset(x1 * tw, y1 * th));
        textureCoords.add(Offset(x0 * tw, y1 * th));
        textureCoords.add(Offset(x0 * tw, y0 * th));
      }
    }

    _positions = positions;
    _textureCoords = textureCoords;
  }

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    final canvas = context.canvas;

    final transformed = _positions.map((Offset pos) {
      final total = _offsets.map(
            (Offset offset) {
          final delta = pos - offset;
          final a = math.atan2(delta.dx, delta.dy);
          return Offset(math.sin(a) * _radius * 0.5, math.cos(a) * _radius * 0.5);
        },
      ).fold<Offset>(Offset.zero, (prev, offset) => prev + offset);
      return pos + (total / _offsets.length.toDouble());
    }).toList();

    List<Color>? colors;
    if (debugPaintSizeEnabled) {
      colors = List<Color>.generate(_positions.length, (int index) {
        final i = (index % 6);
        if (i < 3) {
          return HSLColor.fromAHSL(0.3, 90.0 / 3 * i, 1.0, 0.4).toColor();
        } else {
          return HSLColor.fromAHSL(0.3, 180 + (90.0 / 3 * (i - 3)), 1.0, 0.4).toColor();
        }
      });
    }

    final vertices = ui.Vertices(
      ui.VertexMode.triangles,
      transformed,
      textureCoordinates: _textureCoords,
      colors: colors,
    );

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    canvas.drawVertices(
      vertices,
      ui.BlendMode.dstATop,
      Paint()
        ..shader = _imageShader,
    );

    if (debugPaintSizeEnabled) {
      final canvas = context.canvas;
      for (var i = 0; i < _offsets.length; i++) {
        canvas.drawCircle(_offsets[i], _radius, Paint()
          ..color = Colors.yellow.withOpacity(0.5));
      }
    }

    canvas.restore();
  }
}
