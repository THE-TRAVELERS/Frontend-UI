import 'package:control_panel/models/charpoint.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final List<ChartPoint> points;
  final String title;

  const CustomLineChart(this.points, {this.title = 'New chart', super.key});

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
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              axisNameSize: 22,
              axisNameWidget: Center(
                  child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
              sideTitles: const SideTitles(showTitles: false),
            ),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                reservedSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
