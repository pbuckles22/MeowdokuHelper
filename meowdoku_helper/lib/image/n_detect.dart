import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Early parse output: grid size known; cell values filled in US-2.4.
class GridParseShell {
  const GridParseShell({
    required this.gridSize,
    required this.state,
    required this.regions,
  });

  final int gridSize;
  final Uint8List state;
  final Uint8List regions;
}

/// Counts distinct region fill colors inside the board bounding box → N.
///
/// Star Battle rule: an N×N board has exactly N color regions.
int detectGridSize(img.Image image) {
  final bbox = _findRegionBoundingBox(image);
  final buckets = _sampleRegionColorBuckets(image, bbox);
  return _clusterRegionColors(buckets);
}

/// Allocates [state] and [regions] arrays of length N² (zeroed until US-2.4).
GridParseShell gridParseShell(int gridSize) {
  final len = gridSize * gridSize;
  return GridParseShell(
    gridSize: gridSize,
    state: Uint8List(len),
    regions: Uint8List(len),
  );
}

({int left, int top, int right, int bottom}) _findRegionBoundingBox(
  img.Image image,
) {
  var minX = image.width, minY = image.height, maxX = 0, maxY = 0;
  var found = false;

  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final p = image.getPixel(x, y);
      if (!_isRegionFill(p.r.toInt(), p.g.toInt(), p.b.toInt())) continue;
      found = true;
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
    }
  }

  if (!found) {
    throw StateError('No region fill colors found in image');
  }

  return (left: minX, top: minY, right: maxX, bottom: maxY);
}

Map<String, int> _sampleRegionColorBuckets(
  img.Image image,
  ({int left, int top, int right, int bottom}) bbox,
) {
  final buckets = <String, int>{};
  const sampleStep = 4;
  const quantStep = 16;

  for (var y = bbox.top; y <= bbox.bottom; y += sampleStep) {
    for (var x = bbox.left; x <= bbox.right; x += sampleStep) {
      final p = image.getPixel(x, y);
      final r = _quantize(p.r.toInt(), quantStep);
      final g = _quantize(p.g.toInt(), quantStep);
      final b = _quantize(p.b.toInt(), quantStep);
      if (!_isRegionFill(r, g, b)) continue;
      final key = '$r,$g,$b';
      buckets[key] = (buckets[key] ?? 0) + 1;
    }
  }

  return buckets;
}

int _clusterRegionColors(Map<String, int> buckets) {
  if (buckets.isEmpty) {
    throw StateError('No region fill colors found in grid area');
  }

  const mergeThreshold = 32.0;
  const minFractionOfDominant = 0.03;

  final sorted = buckets.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final minCount =
      (sorted.first.value * minFractionOfDominant).round().clamp(100, 1 << 30);

  final representatives = <List<int>>[];
  final clusterCounts = <int>[];

  for (final entry in sorted) {
    if (entry.value < minCount) continue;
    final rgb = entry.key.split(',').map(int.parse).toList();
    var merged = false;
    for (var i = 0; i < clusterCounts.length; i++) {
      if (_colorDistance(representatives[i], rgb) < mergeThreshold) {
        clusterCounts[i] += entry.value;
        merged = true;
        break;
      }
    }
    if (!merged) {
      representatives.add(rgb);
      clusterCounts.add(entry.value);
    }
  }

  if (clusterCounts.isEmpty) {
    throw StateError('Could not cluster region fill colors');
  }

  return clusterCounts.length;
}

int _quantize(int channel, int step) => (channel / step).round() * step;

bool _isBackground(int r, int g, int b) {
  if (r > 230 && g > 230 && b > 225) return true;
  if (r < 45 && g < 45 && b < 45) return true;
  return false;
}

bool _isRegionFill(int r, int g, int b) {
  if (_isBackground(r, g, b)) return false;
  final maxC = max(r, max(g, b));
  final minC = min(r, min(g, b));
  return (maxC - minC) >= 20 && maxC >= 80;
}

double _colorDistance(List<int> a, List<int> b) {
  final dr = a[0] - b[0], dg = a[1] - b[1], db = a[2] - b[2];
  return sqrt(dr * dr + dg * dg + db * db);
}
