import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inovasy_prototype/models/date_names.dart';

class RankingChart extends StatefulWidget {
  final List<DateTime> chartDates;
  final List<double> chartValues;
  final String selectedMenuName;

  const RankingChart({
    super.key,
    required this.chartDates,
    required this.chartValues,
    required this.selectedMenuName,
  });

  @override
  State<RankingChart> createState() => _RankingChartState();
}

class _RankingChartState extends State<RankingChart> {
  late int selectedGraphIndex = widget.chartDates.length ~/ 3;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              widget.chartDates.length,
              (index) => FlSpot(index.toDouble(), widget.chartValues[index]),
            ),
            color: Colors.white,
            barWidth: 1,
            isCurved: true,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true, // Always show dots
              getDotPainter: (spot, percent, barData, index) {
                bool isSelected = selectedGraphIndex == index;
                return FlDotCirclePainter(
                  radius: isSelected ? 6 : 3, // Bigger dot when selected
                  color: Colors.white,
                  strokeWidth: isSelected ? 3 : 0,
                  strokeColor: Colors.blueAccent,
                );
              },
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return const TouchedSpotIndicatorData(
                FlLine(color: Colors.transparent),
                FlDotData(),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    '${spot.y.toStringAsFixed(0)} ${widget.selectedMenuName.toLowerCase()}\n',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text:
                            'Tanggal ${widget.chartDates[spot.x.toInt()].day} ${monthNamesIndonesian[widget.chartDates[spot.x.toInt()].month - 1].substring(0, 3)}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (event is FlTapUpEvent && response?.lineBarSpots != null) {
              setState(() {
                selectedGraphIndex = response!.lineBarSpots!.first.spotIndex;
              });
            }
          },
        ),
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(
            y: widget.chartValues[selectedGraphIndex],
            color: Colors.white.withOpacity(0.5),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ]),
      ),
    );
  }
}
