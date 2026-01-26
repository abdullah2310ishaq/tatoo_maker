import 'package:flutter/material.dart';
import 'character_box_widget.dart';

/// Grid widget for displaying character boxes in rows of 4
class CharacterBoxesGrid extends StatelessWidget {
  final String name;
  final bool isDark;

  const CharacterBoxesGrid({
    super.key,
    required this.name,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final characters = name.toUpperCase().split('');
    final rows = <List<String>>[];

    // Split into rows of 4
    for (int i = 0; i < characters.length; i += 4) {
      rows.add(
        characters.sublist(
          i,
          (i + 4 < characters.length) ? i + 4 : characters.length,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate size based on available width
        // 4 items per row, with small padding for gaps
        const horizontalPadding = 30.0; // 10 left, 20 right
        const itemsPerRow = 4;
        const itemPadding = 4.0; // 2px on each side
        final availableWidth = constraints.maxWidth - horizontalPadding;
        final totalItemPadding = itemPadding * itemsPerRow;
        final itemWidth = (availableWidth - totalItemPadding) / itemsPerRow;
        // Make character boxes smaller to prevent overflow
        final boxSize = itemWidth.clamp(30.0, 42.0);
        final svgHeight = boxSize * 1.0;

        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: row.map((char) {
                    return CharacterBoxWidget(
                      letter: char,
                      isDark: isDark,
                      boxSize: boxSize,
                      svgHeight: svgHeight,
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
