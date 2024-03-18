import 'package:control_panel/pages/home/logic/controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final List<ChartPoint> points;

  const CustomLineChart(this.points, {super.key});

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
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(interval: 1, showTitles: true)),
          ),
        ),
      ),
    );
  }
}
