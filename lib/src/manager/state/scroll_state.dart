part of '../../../pluto_grid.dart';

abstract class IScrollState {
  /// Controller to control the scrolling of the grid.
  PlutoScrollController get scroll;

  void setScroll(PlutoScrollController scroll);

  /// [direction] Scroll direction
  /// [offset] Scroll position
  void scrollByDirection(MoveDirection direction, double offset);

  /// Whether the cell can be scrolled when moving.
  bool canHorizontalCellScrollByDirection(
    MoveDirection direction,
    PlutoColumn columnToMove,
  );

  /// Scroll to [rowIdx] position.
  void moveScrollByRow(MoveDirection direction, int rowIdx);

  /// Scroll to [columnIdx] position.
  void moveScrollByColumn(MoveDirection direction, int columnIdx);

  bool needMovingScroll(Offset offset, MoveDirection move);
}

mixin ScrollState implements IPlutoState {
  PlutoScrollController get scroll => _scroll;

  PlutoScrollController _scroll;

  void setScroll(PlutoScrollController scroll) {
    _scroll = scroll;
  }

  void scrollByDirection(MoveDirection direction, double offset) {
    if (direction.vertical) {
      _scroll.vertical.jumpTo(offset);
    } else {
      _scroll.horizontal.jumpTo(offset);
    }
  }

  bool canHorizontalCellScrollByDirection(
    MoveDirection direction,
    PlutoColumn columnToMove,
  ) {
    // 고정 컬럼이 보여지는 상태에서 이동 할 컬럼이 고정 컬럼인 경우 스크롤 불필요
    return !(showFixedColumn == true && columnToMove.fixed.isFixed);
  }

  void moveScrollByRow(MoveDirection direction, int rowIdx) {
    if (!direction.vertical) {
      return;
    }

    final double rowSize = PlutoDefaultSettings.rowTotalHeight;

    final double gridOffset =
        PlutoDefaultSettings.gridPadding + PlutoDefaultSettings.shadowLineSize;

    final double screenOffset =
        _scroll.verticalOffset + offsetHeight - rowSize - gridOffset;

    double offsetToMove =
        direction.isUp ? (rowIdx - 1) * rowSize : (rowIdx + 1) * rowSize;

    final bool inScrollStart = _scroll.verticalOffset <= offsetToMove;

    final bool inScrollEnd = offsetToMove + rowSize <= screenOffset;

    if (inScrollStart && inScrollEnd) {
      return;
    } else if (inScrollEnd == false) {
      offsetToMove =
          _scroll.verticalOffset + offsetToMove + rowSize - screenOffset;
    }

    scrollByDirection(direction, offsetToMove);
  }

  void moveScrollByColumn(MoveDirection direction, int columnIdx) {
    if (!direction.horizontal) {
      return;
    }

    final PlutoColumn columnToMove =
        _columns[columnIndexesForShowFixed[columnIdx + direction.offset]];

    if (!canHorizontalCellScrollByDirection(
      direction,
      columnToMove,
    )) {
      return;
    }

    // 이동할 스크롤 포지션 계산을 위해 이동 할 컬럼까지의 넓이 합계를 구한다.
    double offsetToMove = showFixedColumn == true
        ? bodyColumnsWidthAtColumnIdx(
            columnIdx + direction.offset - leftFixedColumnIndexes.length)
        : columnsWidthAtColumnIdx(columnIdx + direction.offset);

    final double screenOffset = showFixedColumn == true
        ? maxWidth - leftFixedColumnsWidth - rightFixedColumnsWidth
        : maxWidth;

    if (direction.isRight) {
      if (offsetToMove > _scroll.horizontal.offset) {
        offsetToMove -= screenOffset;
        offsetToMove += PlutoDefaultSettings.totalShadowLineWidth;
        offsetToMove += columnToMove.width;
        offsetToMove += scrollOffsetByFixedColumn;

        if (offsetToMove < _scroll.horizontal.offset) {
          return;
        }
      }
    } else {
      final offsetToNeed = offsetToMove +
          columnToMove.width +
          PlutoDefaultSettings.totalShadowLineWidth;

      final currentOffset = screenOffset + _scroll.horizontal.offset;

      if (offsetToNeed > currentOffset) {
        offsetToMove = _scroll.horizontal.offset + offsetToNeed - currentOffset;
        offsetToMove += scrollOffsetByFixedColumn;
      } else if (offsetToMove > _scroll.horizontal.offset) {
        return;
      }
    }

    scrollByDirection(direction, offsetToMove);
  }

  bool needMovingScroll(Offset offset, MoveDirection move) {
    if (selectingMode.isNone) {
      return false;
    }

    switch (move) {
      case MoveDirection.Left:
        return offset.dx < bodyLeftScrollOffset;
      case MoveDirection.Right:
        return offset.dx > bodyRightScrollOffset;
      case MoveDirection.Up:
        return offset.dy < bodyUpScrollOffset;
      case MoveDirection.Down:
        return offset.dy > bodyDownScrollOffset;
    }

    return false;
  }
}
