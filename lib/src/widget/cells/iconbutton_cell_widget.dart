part of '../../../pluto_grid.dart';

class IconButtonCellWidget extends DefaultCellWidget implements _TextBaseMixinImpl {
  final PlutoStateManager stateManager;
  final PlutoCell cell;
  final PlutoColumn column;

  IconButtonCellWidget({
    this.stateManager,
    this.cell,
    this.column,
  });

  @override
  _IconButtonCellWidgetState createState() => _IconButtonCellWidgetState();
}

class _IconButtonCellWidgetState extends _DefaultCellWidgetState {

  _IconButtonCellWidgetState();

  Widget getCellWidget() {
    if (widget.column.hasRenderer) {
      return widget.column.renderer(PlutoColumnRendererContext(
        column: widget.column,
        rowIdx: widget.rowIdx,
        row: thisRow,
        cell: widget.cell,
        stateManager: widget.stateManager,
      ));
    }
    final type = widget.column.type as PlutoColumnTypeIconButton;
    return type.buildWidget(widget.cell.value);
  }
}