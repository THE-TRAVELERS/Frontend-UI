// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:collection/collection.dart';

/// Class responsible for handling the network status.
class NetworkStatus {
  static bool get online => html.window.navigator.onLine ?? false;
}

/// Represents a point on a chart with X and Y coordinates.
///
/// The `x` property represents the X coordinate and the `y` property represents the Y coordinate.
class ChartPoint {
  final double x;
  final double y;
  ChartPoint({required this.x, required this.y});
}

/// Converts a list of double values into a list of `ChartPoint` instances.
///
/// Each `ChartPoint`'s X coordinate is the index of the value in the input list (starting from 1),
/// and the Y coordinate is the value itself.
List<ChartPoint> getValues(List<double> data) {
  return data
      .mapIndexed((index, element) =>
          ChartPoint(x: (index + 1).toDouble(), y: element.toDouble()))
      .toList();
}

/// Updates the list of values.
///
/// When a new value is added, it is placed at the end of the list.
/// The existing values are shifted to the left, and the least recent value is removed.
List<double> update(value, valuesList) {
  double valueMemory1 = 0;
  double valueMemory2 = 0;

  if (valuesList.length < 10) {
    valuesList.add(value.toDouble());
  } else if (valuesList.length == 10) {
    for (int i = 9; i > 0; i--) {
      if (i == 9) {
        valueMemory1 = valuesList[i];
        valueMemory2 = valuesList[i - 1];
        valuesList[i] = value;
      } else {
        valuesList[i] = valueMemory1;
        valueMemory1 = valueMemory2;
        valueMemory2 = valuesList[i - 1];
      }
    }
    valuesList[0] = valueMemory1;
  }

  return valuesList;
}

/// Convert the value in String to double
double convert(String value) {
  return double.parse(value);
}
