import 'package:flutter/material.dart';
import 'package:meowdoku_helper/image/n_detect.dart';

/// Stateless N×N board preview with optional next-move highlight (US-3.2).
class PuzzleGridPreview extends StatelessWidget {
  /// Creates a read-only grid preview.
  const PuzzleGridPreview({
    required this.gridSize,
    required this.state,
    required this.highlightIndex,
    super.key,
  });

  final int gridSize;
  final List<int> state;
  final int highlightIndex;

  static const String stalledBannerKey = 'stalled-banner';
  static const String highlightRingKey = 'highlight-ring';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 280.0;
        final gap = 2.0;
        final cellSide = (side - gap * (gridSize - 1)) / gridSize;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (highlightIndex == -1)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Board stalled — no deterministic move (Tiers 1–6)',
                  key: const Key(stalledBannerKey),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              width: side,
              height: side,
              child: Column(
                children: [
                  for (var row = 0; row < gridSize; row++) ...[
                    if (row > 0) SizedBox(height: gap),
                    Row(
                      children: [
                        for (var col = 0; col < gridSize; col++) ...[
                          if (col > 0) SizedBox(width: gap),
                          SizedBox(
                            width: cellSide,
                            height: cellSide,
                            child: _buildCell(
                              theme,
                              index: row * gridSize + col,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(ThemeData theme, {required int index}) {
    final cellState = state[index];
    final isHighlighted = highlightIndex >= 0 && index == highlightIndex;

    return DecoratedBox(
      key: ValueKey('puzzle-cell-$index'),
      decoration: BoxDecoration(
        color: _cellFill(theme, cellState),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: _cellGlyph(theme, cellState)),
          if (isHighlighted)
            DecoratedBox(
              key: const Key(highlightRingKey),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.secondary,
                  width: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _cellFill(ThemeData theme, int cellState) {
    return switch (cellState) {
      cellCat => theme.colorScheme.primaryContainer,
      cellBlocked => theme.colorScheme.surfaceContainerHighest,
      _ => theme.colorScheme.surface,
    };
  }

  Widget? _cellGlyph(ThemeData theme, int cellState) {
    return switch (cellState) {
      cellCat => Icon(
        Icons.pets,
        size: 16,
        color: theme.colorScheme.onPrimaryContainer,
      ),
      cellBlocked => Icon(
        Icons.close,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      _ => null,
    };
  }
}
