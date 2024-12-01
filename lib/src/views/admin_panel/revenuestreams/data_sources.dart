// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/constants.dart';
import '../../../../config/functions.dart';
import '/models/revenuestreamspaginated.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}

int _idCounter = 0;

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class DessertDataSource extends DataTableSource {
  DessertDataSource.empty(this.context) {
    desserts = [];
  }

  DessertDataSource(this.context,
      [sortedByCalories = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {
    desserts = _dessertsX3;
    // if (sortedByCalories) {
    //   sort((d) => d.calories, true);
    // }
  }

  final BuildContext context;
  late List<RevenueStreams> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(RevenueStreams d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  // void updateSelectedDesserts(RestorableDessertSelections selectedRows) {
  //   _selectedCount = 0;
  //   for (var i = 0; i < desserts.length; i += 1) {
  //     var dessert = desserts[i];
  //     if (selectedRows.isSelected(i)) {
  //       dessert.selected = true;
  //       _selectedCount += 1;
  //     } else {
  //       dessert.selected = false;
  //     }
  //   }
  //   notifyListeners();
  // }

  @override
  DataRow2 getRow(int index, [Color? color]) {
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= desserts.length) throw 'index > _desserts.length';
    final dessert = desserts[index];
    return DataRow2.byIndex(
      index: index,
      // selected: dessert.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        // if (dessert.selected != value) {
        //   _selectedCount += value! ? 1 : -1;
        //   assert(_selectedCount >= 0);
        //   dessert.selected = value;
        //   notifyListeners();
        // }
      },
      onTap: hasRowTaps
          ? () => _showSnackbar(context, 'Tapped on row ${dessert.regno}')
          : null,
      onDoubleTap: hasRowTaps
          ? () =>
              _showSnackbar(context, 'Double Tapped on row ${dessert.model}')
          : null,
      onLongPress: hasRowTaps
          ? () => _showSnackbar(context, 'Long pressed on row ${dessert.color}')
          : null,
      onSecondaryTap: hasRowTaps
          ? () => _showSnackbar(
              context, 'Right clicked on row ${dessert.regreferenceno}')
          : null,
      onSecondaryTapDown: hasRowTaps
          ? (d) =>
              _showSnackbar(context, 'Right button down on row ${dessert.type}')
          : null,
      // specificRowHeight:
      //     hasRowHeightOverrides && dessert.fat >= 25 ? 100 : null,
      cells: [
        DataCell(Text(dessert.regno)),
        DataCell(Text(dessert.model)),
        DataCell(Text('${dessert.color}')),
        DataCell(Text('${dessert.regreferenceno}')),
        DataCell(Text('${dessert.type}')),
        DataCell((dessert.status == "1")
            ? Chip(label: Text("Active"))
            : (dessert.status == "2")
                ? Chip(label: Text("Archived"))
                : Chip(label: Text("Pending"))),
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit_square, size: 30, color: Colors.blue)),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete_outline, size: 30, color: Colors.red)),
          ],
        )),
      ],
    );
  }

  @override
  int get rowCount => desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  // void selectAll(bool? checked) {
  //   for (final dessert in desserts) {
  //     dessert.selected = checked ?? false;
  //   }
  //   _selectedCount = (checked ?? false) ? desserts.length : 0;
  //   notifyListeners();
  // }
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class DessertDataSourceAsync extends AsyncDataTableSource {
  final String categoryId;
  Future<List<RevenueStreams>> getStreams(String categoryId) async {
    List<RevenueStreams> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl +
        "revenuestreams/category/default/e2360992-9f38-11ef-bf99-42010a800002");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      RevenueStreamsPaginatedModel incidentsmodel =
          RevenueStreamsPaginatedModel.fromJson(items);

      returnValue = incidentsmodel.items;
      // setState(() {
      _dessertsX3 = incidentsmodel.items;
      // });
      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  DessertDataSourceAsync(this.categoryId) {
    getStreams(this.categoryId);
    print('DessertDataSourceAsync created');
  }

  DessertDataSourceAsync.empty(this.categoryId) {
    _empty = true;
    print('DessertDataSourceAsync.empty created');
  }

  DessertDataSourceAsync.error(this.categoryId) {
    _errorCounter = 0;
    print('DessertDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  RangeValues? _caloriesFilter;

  RangeValues? get caloriesFilter => _caloriesFilter;
  set caloriesFilter(RangeValues? calories) {
    _caloriesFilter = calories;
    refreshDatasource();
  }

  final DesertsFakeWebService _repo = DesertsFakeWebService();

  String _sortColumn = "name";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  Future<int> getTotalRecords() {
    return Future<int>.delayed(
        const Duration(milliseconds: 0), () => _empty ? 0 : _dessertsX3.length);
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    print('getRows($startIndex, $count)');
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(startIndex >= 0);

    // List returned will be empty is there're fewer items than startingAt
    var x = _empty
        ? await Future.delayed(const Duration(milliseconds: 2000),
            () => DesertsFakeWebServiceResponse(0, []))
        : await _repo.getData(
            startIndex, count, _caloriesFilter, _sortColumn, _sortAscending);

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((dessert) {
          return DataRow(
            key: ValueKey<String>(dessert.id),
            //selected: dessert.selected,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<String>(dessert.id), value);
              }
            },
            cells: [
              DataCell(Text(dessert.regno)),
              DataCell(Text(dessert.model)),
              DataCell(Text('${dessert.color}')),
              DataCell(Text('${dessert.regreferenceno}')),
              DataCell(Text('${dessert.type}')),
              DataCell((dessert.status == "1")
                  ? SizedBox(
                      height: 40,
                      child: Chip(
                          side: BorderSide(width: 1.0, color: Colors.green),
                          elevation: 8.0,
                          padding: EdgeInsets.all(2),
                          backgroundColor: Colors.greenAccent[100],
                          shadowColor: Colors.black,
                          avatar: CircleAvatar(
                            maxRadius: 4.0,
                            backgroundColor: Colors.green,
                          ),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          label: Text(
                            "Active",
                          )),
                    )
                  : (dessert.status == "2")
                      ? SizedBox(
                          height: 40,
                          child: Chip(
                              side: BorderSide(width: 1.0, color: Colors.red),
                              elevation: 8.0,
                              padding: EdgeInsets.all(2),
                              backgroundColor: Colors.red.shade50,
                              shadowColor: Colors.black,
                              avatar: CircleAvatar(
                                maxRadius: 4.0,
                                backgroundColor: Colors.red,
                              ),
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              label: Text(
                                "Archived",
                              )),
                        )
                      : SizedBox(
                          height: 40,
                          child: Chip(
                              side: BorderSide(width: 1.0, color: Colors.amber),
                              elevation: 8.0,
                              padding: EdgeInsets.all(2),
                              backgroundColor: Colors.amber.shade100,
                              shadowColor: Colors.black,
                              avatar: CircleAvatar(
                                maxRadius: 4.0,
                                backgroundColor: Colors.amber,
                              ),
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              label: Text(
                                "Pending",
                              )),
                        )),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon:
                          Icon(Icons.edit_note, size: 30, color: Colors.blue)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete_outline,
                          size: 30, color: Colors.red)),
                ],
              )),
            ],
          );
        }).toList());

    return r;
  }
}

class DesertsFakeWebServiceResponse {
  DesertsFakeWebServiceResponse(this.totalRecords, this.data);

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<RevenueStreams> data;
}

class DesertsFakeWebService {
  int Function(RevenueStreams, RevenueStreams)? _getComparisonFunction(
      String column, bool ascending) {
    var coef = ascending ? 1 : -1;
    switch (column) {
      case 'Reg No':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.regno.compareTo(d2.regno);
      case 'Model':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.model.compareTo(d2.model);
      case 'Color':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.color.compareTo(d2.color);
      case 'Reg Reference':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.regreferenceno.compareTo(d2.regreferenceno);
      case 'Type':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.type.compareTo(d2.type);
      case 'Status':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.status.compareTo(d2.status);
      case '':
        return (RevenueStreams d1, RevenueStreams d2) =>
            coef * d1.regno.compareTo(d2.regno);
    }

    return null;
  }

  Future<DesertsFakeWebServiceResponse> getData(int startingAt, int count,
      RangeValues? caloriesFilter, String sortedBy, bool sortedAsc) async {
    return Future.delayed(
        Duration(
            milliseconds: startingAt == 0
                ? 1000
                : startingAt < 20
                    ? 1000
                    : 400), () {
      var result = _dessertsX3;
      // result.sort(_getComparisonFunction(sortedBy, sortedAsc));
      return DesertsFakeWebServiceResponse(
          result.length, result.skip(startingAt).take(count).toList());
    });
  }
}

int _selectedCount = 0;
List<RevenueStreams> _dessertsX3 = <RevenueStreams>[];

_showSnackbar(BuildContext context, String text, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: const Duration(seconds: 1),
    content: Text(text),
  ));
}
