// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:collection/collection.dart';

class NetworkStatus {
  static bool get online => html.window.navigator.onLine ?? false;
}
///class value for mapping. X for coordinates and Y for value.
class Value {
  final double x;
  final double y;
  Value({required this.x, required this.y});
}

///Convert the values in Value for having the index of the values.
List<Value> getValues(List<double> data) {
  return data
      .mapIndexed((index, element) =>
          Value(x: (index + 1).toDouble(), y: element.toDouble()))
      .toList();
}

/// update the list of values and has to be converted next.
///
/// The new value comes at the end of the list and the rest of
/// values got moved to the left with the less recent one disapearing
///
/// Didn't have been tested yet with Websocket
List<double> update(value, valueListe) {
  double valueMemory1 = 0;
  double valueMemory2 = 0;
  if (valueListe.length < 10) {
    valueListe.add(value.toDouble());
  } else if (valueListe.length == 10) {
    for (int i = 9; i > 0; i--) {
      if (i == 9) {
        valueMemory1 = valueListe[i];
        valueMemory2 = valueListe[i - 1];
        valueListe[i] = value;
      } else {
        valueListe[i] = valueMemory1;
        valueMemory1 = valueMemory2;
        valueMemory2 = valueListe[i - 1];
      }
    }
    valueListe[0] = valueMemory1;
  }
  return valueListe;
}

///Convert the data coming from the websocket to an understanble type of data
double convert(String value) {
  // Virer les caractères inutiles initiaux
  return double.parse((value.substring(6)));
}
