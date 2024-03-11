import 'package:control_panel/pages/home/logic/controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final List<Value> points;

  const CustomLineChart(this.points, {Key? key}) : super(key: key);

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2,
        child: LineChart(
          LineChartData(
              minX: 1,
              maxX: 10,
              lineBarsData: [
                LineChartBarData(
                    spots: widget.points
                        .map((point) => FlSpot(point.x, point.y))
                        .toList(),
                    isCurved: false,
                    dotData: const FlDotData(show: true)),
              ],
              titlesData: const FlTitlesData(
                  show: true,
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(interval: 1, showTitles: true)))),
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
