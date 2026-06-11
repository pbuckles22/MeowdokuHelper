import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Cell state values (matches Rust `board.rs`).
const int cellEmpty = 0;
const int cellCat = 1;
const int cellBlocked = 2;

/// Parsed grid: N, flattened [state] and [regions] (length N²).
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

/// Full parse: detect N, sample each cell → [state] and [regions].
GridParseShell parseGridFromImage(img.Image image) {
  final rawBbox = findRegionBoundingBox(image);
  final palette = buildRegionPalette(image, rawBbox);
  final n = palette.length;
  final bbox = refineGridBoundingBox(image, rawBbox);
  final len = n * n;
  final state = Uint8List(len);
  final regions = Uint8List(len);

  final gridWidth = bbox.right - bbox.left + 1;
  final gridHeight = bbox.bottom - bbox.top + 1;
  final cellW = gridWidth / n;
  final cellH = gridHeight / n;

  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final left = bbox.left + x * cellW;
      final top = bbox.top + y * cellH;
      final centerX = (left + cellW / 2).round().clamp(0, image.width - 1);
      final centerY = (top + cellH / 2).round().clamp(0, image.height - 1);
      final offsetX =
          (centerX - cellW * 0.15).round().clamp(0, image.width - 1);
      final offsetY =
          (centerY - cellH * 0.15).round().clamp(0, image.height - 1);
      final cornerX =
          (left + cellW * 0.25).round().clamp(0, image.width - 1);
      final cornerY =
          (top + cellH * 0.25).round().clamp(0, image.height - 1);

      final center = image.getPixel(centerX, centerY);
      final offset = image.getPixel(offsetX, offsetY);
      final corner = image.getPixel(cornerX, cornerY);

      final cr = center.r.toInt(), cg = center.g.toInt(), cb = center.b.toInt();
      final or = offset.r.toInt(), og = offset.g.toInt(), ob = offset.b.toInt();
      final kr = corner.r.toInt(), kg = corner.g.toInt(), kb = corner.b.toInt();

      final idx = y * n + x;
      regions[idx] = _mapCellToRegionId(
        cr,
        cg,
        cb,
        kr,
        kg,
        kb,
        palette,
      );
      state[idx] = _classifyCellState(cr, cg, cb, or, og, ob);
    }
  }

  return GridParseShell(gridSize: n, state: state, regions: regions);
}

/// Counts distinct region fill colors inside the board bounding box → N.
///
/// Star Battle rule: an N×N board has exactly N color regions.
int detectGridSize(img.Image image) {
  final bbox = findRegionBoundingBox(image);
  return buildRegionPalette(image, bbox).length;
}

/// Allocates zeroed [state] and [regions] arrays of length N².
GridParseShell gridParseShell(int gridSize) {
  final len = gridSize * gridSize;
  return GridParseShell(
    gridSize: gridSize,
    state: Uint8List(len),
    regions: Uint8List(len),
  );
}

/// Region-fill bounding box for grid slicing.
({int left, int top, int right, int bottom}) findRegionBoundingBox(
  img.Image image,
) {
  var minX = image.width, minY = image.height, maxX = 0, maxY = 0;
  var found = false;

  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final p = image.getPixel(x, y);
      if (!isRegionFill(p.r.toInt(), p.g.toInt(), p.b.toInt())) continue;
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

/// Trims UI padding from [bbox] using region-fill density profiles.
({int left, int top, int right, int bottom}) refineGridBoundingBox(
  img.Image image,
  ({int left, int top, int right, int bottom}) bbox,
) {
  var top = bbox.top;
  var bottom = bbox.bottom;
  var left = bbox.left;
  var right = bbox.right;

  final rowProfile = _regionFillProfile(
    image,
    bbox,
    horizontal: true,
  );
  top = _trimProfileEdge(rowProfile, top, fromStart: true);
  bottom = _trimProfileEdge(rowProfile, bbox.top, fromStart: false);

  final colBbox = (left: left, top: top, right: right, bottom: bottom);
  final colProfile = _regionFillProfile(
    image,
    colBbox,
    horizontal: false,
  );
  left = _trimProfileEdge(colProfile, left, fromStart: true);
  right = _trimProfileEdge(colProfile, bbox.left, fromStart: false);

  return (left: left, top: top, right: right, bottom: bottom);
}

List<int> _regionFillProfile(
  img.Image image,
  ({int left, int top, int right, int bottom}) bbox, {
  required bool horizontal,
}) {
  if (horizontal) {
    final profile = <int>[];
    for (var y = bbox.top; y <= bbox.bottom; y++) {
      var count = 0;
      for (var x = bbox.left; x <= bbox.right; x++) {
        final p = image.getPixel(x, y);
        if (isRegionFill(p.r.toInt(), p.g.toInt(), p.b.toInt())) count++;
      }
      profile.add(count);
    }
    return profile;
  }

  final profile = <int>[];
  for (var x = bbox.left; x <= bbox.right; x++) {
    var count = 0;
    for (var y = bbox.top; y <= bbox.bottom; y++) {
      final p = image.getPixel(x, y);
      if (isRegionFill(p.r.toInt(), p.g.toInt(), p.b.toInt())) count++;
    }
    profile.add(count);
  }
  return profile;
}

int _trimProfileEdge(
  List<int> profile,
  int axisStart, {
  required bool fromStart,
}) {
  if (profile.isEmpty) return axisStart;
  final maxCount = profile.reduce(max);
  if (maxCount == 0) return axisStart;
  final threshold = (maxCount * 0.55).round();

  if (fromStart) {
    for (var i = 0; i < profile.length; i++) {
      if (profile[i] >= threshold) return axisStart + i;
    }
    return axisStart;
  }

  for (var i = profile.length - 1; i >= 0; i--) {
    if (profile[i] >= threshold) return axisStart + i;
  }
  return axisStart + profile.length - 1;
}

/// Sorted palette of N representative region RGB triples (stable order).
List<List<int>> buildRegionPalette(
  img.Image image,
  ({int left, int top, int right, int bottom}) bbox,
) {
  final buckets = _sampleRegionColorBuckets(image, bbox);
  return _clusterRegionPalette(buckets);
}

int _mapCellToRegionId(
  int cr,
  int cg,
  int cb,
  int kr,
  int kg,
  int kb,
  List<List<int>> palette,
) {
  if (isRegionFill(cr, cg, cb)) {
    return _nearestPaletteId(cr, cg, cb, palette);
  }
  if (isRegionFill(kr, kg, kb)) {
    return _nearestPaletteId(kr, kg, kb, palette);
  }
  return _nearestPaletteId(cr, cg, cb, palette);
}

int _nearestPaletteId(
  int r,
  int g,
  int b,
  List<List<int>> palette,
) {
  var bestId = 1;
  var bestDist = double.infinity;
  for (var i = 0; i < palette.length; i++) {
    final d = _colorDistance(palette[i], [r, g, b]);
    if (d < bestDist) {
      bestDist = d;
      bestId = i + 1;
    }
  }
  return bestId;
}

int _classifyCellState(int cr, int cg, int cb, int or, int og, int ob) {
  if (_isCatMarker(cr, cg, cb, or, og, ob)) return cellCat;
  if (_isBlockedMarker(cr, cg, cb, or, og, ob)) return cellBlocked;
  return cellEmpty;
}

/// Cat face: light center with dark feature at offset (top-left of center).
bool _isCatMarker(int cr, int cg, int cb, int or, int og, int ob) {
  final centerLight = min(cr, min(cg, cb)) >= 170;
  final offsetDark = max(or, max(og, ob)) <= 75;
  return centerLight && offsetDark;
}

/// Blocked (X): dark stroke on region fill, or bright X wash over region.
bool _isBlockedMarker(int cr, int cg, int cb, int or, int og, int ob) {
  final offsetDark =
      max(or, max(og, ob)) <= 90 && min(or, min(og, ob)) >= 25;
  if (offsetDark &&
      min(cr, min(cg, cb)) < 170 &&
      isRegionFill(cr, cg, cb)) {
    return true;
  }
  final centerBright = min(cr, min(cg, cb)) >= 240;
  if (centerBright && isRegionFill(or, og, ob)) return true;
  return false;
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
      if (!isRegionFill(r, g, b)) continue;
      final key = '$r,$g,$b';
      buckets[key] = (buckets[key] ?? 0) + 1;
    }
  }

  return buckets;
}

List<List<int>> _clusterRegionPalette(Map<String, int> buckets) {
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

  final order = List.generate(representatives.length, (i) => i)
    ..sort((a, b) {
      final byCount = clusterCounts[b].compareTo(clusterCounts[a]);
      if (byCount != 0) return byCount;
      for (var c = 0; c < 3; c++) {
        final byChannel = representatives[a][c].compareTo(representatives[b][c]);
        if (byChannel != 0) return byChannel;
      }
      return 0;
    });

  return [for (final i in order) representatives[i]];
}

int _quantize(int channel, int step) => (channel / step).round() * step;

bool _isBackground(int r, int g, int b) {
  if (r > 230 && g > 230 && b > 225) return true;
  if (r < 45 && g < 45 && b < 45) return true;
  return false;
}

/// Whether RGB looks like a solid region fill (not background, cat, or X).
bool isRegionFill(int r, int g, int b) {
  if (_isBackground(r, g, b)) return false;
  final maxC = max(r, max(g, b));
  final minC = min(r, min(g, b));
  return (maxC - minC) >= 20 && maxC >= 80;
}

double _colorDistance(List<int> a, List<int> b) {
  final dr = a[0] - b[0], dg = a[1] - b[1], db = a[2] - b[2];
  return sqrt(dr * dr + dg * dg + db * db);
}
