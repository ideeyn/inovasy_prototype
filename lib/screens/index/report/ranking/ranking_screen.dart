import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/global/function/string_formatter.dart';
import 'package:inovasy_prototype/models/date_names.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/transaction_model/purchase_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen(
      {super.key,
      required this.listUser,
      required this.listProduct,
      required this.listTransaction,
      required this.dates,
      required this.dailyTransaction});

  final List<UserModel> listUser;
  final List<ProductModel> listProduct;
  final List<TransactionModel> listTransaction;
  final List<DateTime> dates;
  final List<double> dailyTransaction;

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late int selectedGraphIndex = widget.dates.length ~/ 3;
  String selectedMenu = "PRODUK";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
        ),
        backgroundColor: GLOBAL.appLogoColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      backgroundColor: GLOBAL.appLogoColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  'Ranking',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  'Berdasarkan total penjualan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                            widget.dates.length,
                            (index) => FlSpot(index.toDouble(),
                                widget.dailyTransaction[index])),
                        color: Colors.white,
                        barWidth: 1,
                        isCurved: true,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true, // Always show dots
                          getDotPainter: (spot, percent, barData, index) {
                            bool isSelected = selectedGraphIndex == index;
                            return FlDotCirclePainter(
                              radius: isSelected
                                  ? 6
                                  : 3, // Bigger dot when selected
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
                            // Remove horizontal line
                            FlLine(color: Colors.transparent),
                            FlDotData(),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                        getTooltipItems: (spots) => spots
                            .map((spot) {
                              // bool isSelected =
                              //     selectedGraphIndex == spot.spotIndex;
                              // if (!isSelected) return null;
                              return LineTooltipItem(
                                'Rp ${IdeeynCurrencyString.numberToStringIndonesian(spot.y).split(',')[0]}\n', // Custom bubble text
                                const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text:
                                        'Tanggal ${widget.dates[spot.x.toInt()].day} ${monthNamesIndonesian[widget.dates[spot.x.toInt()].month - 1].substring(0, 3)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              );
                            })
                            .whereType<LineTooltipItem>()
                            .toList(),
                      ),
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {
                        if (event is FlTapUpEvent &&
                            response?.lineBarSpots != null) {
                          selectedGraphIndex =
                              response!.lineBarSpots!.first.spotIndex;
                          setState(() {});
                        }
                      },
                    ),
                    extraLinesData: ExtraLinesData(horizontalLines: [
                      HorizontalLine(
                        y: widget.listTransaction
                            .where((t) =>
                                t.date?.day ==
                                widget.dates[selectedGraphIndex].day)
                            .expand((t) => t.purchase ?? <PurchaseModel>[])
                            .map((p) {
                          double price = widget.listProduct
                              .firstWhere((prd) => prd.id == p.id)
                              .price!
                              .toDouble();
                          return p.quantity! * price;
                        }).fold(0, (sum, price) => sum + price),
                        color: Colors.white.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    menu('PRODUK'),
                    menu('PELANGGAN'),
                    menu('SALES'),
                    menu('KABUPATEN'),
                  ],
                ),
              ),
            ],
          ),

          // Draggable Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 1.0, // Expand to full screen
            builder: (context, scrollController) {
              return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Draggable Sheet Content",
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      ...List.generate(
                          20, (index) => ListTile(title: Text("Item $index"))),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  GestureDetector menu(String name) {
    bool isSelected = name == selectedMenu;

    return GestureDetector(
        onTap: () => setState(() => selectedMenu = name),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? Colors.white : null,
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ));
  }
}
