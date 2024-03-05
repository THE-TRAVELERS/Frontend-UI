import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

///class value for mapping. X for coordinates and Y for value.
class Value { 
  final double x;
  final double y;
  Value ({required this.x, required this.y});
}

///Convert the values in Value for having the index of the values.
List<Value> getValues(List<double> data) {
  return data.mapIndexed((index, element) => Value(x: (index+1).toDouble(), y: element.toDouble())).toList();
}

/// update the list of values and has to be converted next.
/// 
/// The new value comes at the end of the list and the rest of 
/// values got moved to the left with the less recent one disapearing 
/// 
/// Didn't have been tested yet with Websocket
List<double> Update(value, valueListe){ 
  double valueMemory1=0;
  double valueMemory2=0;                       
  if (valueListe.length<10) 
  {valueListe.add(value.toDouble());}
  else if (valueListe.length==10)
  {
    for(int i = 9; i>0; i--)
    {
      if(i==9) {
        valueMemory1=valueListe[i];
        valueMemory2=valueListe[i-1];
        valueListe[i]=value;
      }
      else {
        valueListe[i]=valueMemory1;
        valueMemory1=valueMemory2;
        valueMemory2=valueListe[i-1];
      }
    }
    valueListe[0]=valueMemory1;
  }
  return valueListe;
}

///Convert the data coming from the websocket to an understanble type of data
double convert(String value)
{
  return double.parse((value.substring(6)));
}

/// The widget is declared as stateful because the data will be 
/// changed dynamically with the websocket
class LineChartWidget extends StatefulWidget {
  final List<Value> points;

  const LineChartWidget(this.points, {Key? key})
      : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(LineChartData(
        minX: 1,
        maxX: 10,
        lineBarsData: [
          LineChartBarData(
            spots: widget.points.map((point) => FlSpot(point.x, point.y)).toList(),
            isCurved: false,
            dotData: const FlDotData(show: true)
          ),
        ],
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles:  AxisTitles(sideTitles: SideTitles(
            interval: 1,
            showTitles: true
          ))
        ) 
      ),
    ));
  }
}


/// Pour appeler le widget, faire comme ceci : 

/// Déclarer une liste de double en dehors du widget principal : List<double> data = <double> [2,4,6,11,3,6,4,1,1,1];
/// SizedBox( /// the chart has to be part of a box to exist
///   width: 440,
///   height:280,
///   child : LineChartWidget(getValues(data)) 
/// ),
