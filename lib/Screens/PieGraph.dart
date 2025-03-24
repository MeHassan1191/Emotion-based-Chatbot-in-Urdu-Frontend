import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmotionPieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  EmotionPieChart({required this.dataMap});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _generateSections(dataMap),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
      ),
    );
  }

  List<PieChartSectionData> _generateSections(Map<String, double> dataMap) {
    List<PieChartSectionData> sections = [];
    dataMap.forEach((emotion, value) {
      sections.add(PieChartSectionData(
        color: _getColorForEmotion(emotion),
        value: value,
        title: '$emotion (${value.toInt()})',
        radius: 70,
        titleStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      ));
    });
    return sections;
  }

  Color _getColorForEmotion(String emotion) {
    switch (emotion) {
      case 'Happy':
        return Colors.green;
      case 'Sad':
        return Colors.deepOrange;
      case 'Neutral':
        return Colors.teal;
      case 'Fear':
        return Colors.purple;
      case 'Angry':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
