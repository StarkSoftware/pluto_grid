import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../widget/pluto_example_button.dart';
import '../../widget/pluto_example_screen.dart';

class ColumnMovingScreen extends StatefulWidget {
  static const routeName = 'feature/column-moving';

  @override
  _ColumnMovingScreenState createState() => _ColumnMovingScreenState();
}

class _ColumnMovingScreenState extends State<ColumnMovingScreen> {
  List<PlutoColumn> columns;

  List<PlutoRow> rows;

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: '',
        field: 'column_a',
        enableColumnDrag: false,
        enableRowChecked: false,
        enableSorting: false,
        enableContextMenu: false,
        width: 60,
        type: PlutoColumnType.iconbutton(widget: (dynamic value) {
          if (value != null) {
            return IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                doClick(value);
              },
            );
          }
          return Icon(Icons.image_not_supported_outlined);
        })
      ),
      PlutoColumn(
        title: 'Column B',
        field: 'column_b',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Column C',
        field: 'column_c',
        type: PlutoColumnType.text(),
      ),
    ];

    rows = [
      PlutoRow(
        cells: {
          'column_a': PlutoCell(value: "KEY ID"),
          'column_b': PlutoCell(value: 'b1'),
          'column_c': PlutoCell(value: 'https://user-images.githubusercontent.com/1258285/98427754-7341f480-20af-11eb-952a-971295a05b43.png'),
        },
      ),
      PlutoRow(
        cells: {
          'column_a': PlutoCell(value: 'a2'),
          'column_b': PlutoCell(value: 'b2'),
          'column_c': PlutoCell(value: null),
        },
      ),
      PlutoRow(
        cells: {
          'column_a': PlutoCell(value: 'a3'),
          'column_b': PlutoCell(value: 'b3'),
          'column_c': PlutoCell(),
        },
      ),
    ];
  }

  void doClick(dynamic value) {
    print("CLICK");
  }

  @override
  Widget build(BuildContext context) {
    return PlutoExampleScreen(
      title: 'Column moving',
      topTitle: 'Column moving',
      topContents: [
        Text(
            'You can change the column position by dragging the column title left or right.'),
      ],
      topButtons: [
        PlutoExampleButton(
          url:
              'https://github.com/bosskmk/pluto_grid/blob/master/example/lib/screen/feature/column_moving_screen.dart',
        ),
      ],
      body: PlutoGrid(
        columns: columns,
        rows: rows,
        onChanged: (PlutoOnChangedEvent event) {
          print(event);
        },
      ),
    );
  }
}
