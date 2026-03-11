import 'dart:ui';

class GridViewUIParams {
  final double width;
  final double height;
  final double tileHeight;
  final double tileWidth;
  final int rows;
  final int columns;
  final int startPositionRow;
  final int startPositionCol;
  final int finalPositionRow;
  final int finalPositionCol;
  final int gameId;
  final bool isError;
  final Color borderColor;
  final List<String> steps;
  final Color arrowColor;

  GridViewUIParams({
    required this.width,
    required this.height,
    required this.tileHeight,
    required this.tileWidth,
    required this.rows,
    required this.columns,
    required this.startPositionRow,
    required this.startPositionCol,
    required this.finalPositionRow,
    required this.finalPositionCol,
    required this.gameId,
    required this.isError,
    required this.borderColor,
    required this.steps,
    required this.arrowColor,
  });
}
