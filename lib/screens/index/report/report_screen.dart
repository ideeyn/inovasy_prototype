import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/global/function/string_formatter.dart';
import 'package:inovasy_prototype/global/style/buttonstyle.dart';
import 'package:inovasy_prototype/libraries/http_ai.dart';
import 'package:inovasy_prototype/libraries/sharedpref_singleton.dart';
import 'package:inovasy_prototype/models/date_names.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/sales_model/sales_model.dart';
import 'package:inovasy_prototype/models/transaction_model/purchase_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';
import 'package:inovasy_prototype/screens/index/report/ranking/ranking_screen.dart';
import 'package:inovasy_prototype/screens/index/report/widget_report/convex_clipper.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<String> listViewer = LibrarySharedPref.ref.getMasterViewer;
  List<UserModel> listUser = LibrarySharedPref.ref.getMasterUser;
  List<SalesModel> listSales = LibrarySharedPref.ref.getMasterSales;
  List<ProductModel> listProduct = LibrarySharedPref.ref.getMasterProduct;
  List<TransactionModel> listTransaction =
      LibrarySharedPref.ref.getMasterTransaction;
  bool isInitDone = false;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 24));
  DateTime endDate = DateTime.now();
  List<DateTime> dates = [];
  List<double> dailyTransactions = [];
  late int selectedGraphIndex;
  late List<TransactionModel> inDateTransactions;
  // --------------------------------------------------------------------------
  double sellingTotal = 0;
  int transactionCount = 0;
  int customerCount = 0;
  int viewerCount = 0;
  int soldCount = 0;
  int productCount = 0;
  double creditTotal = 0;
  double marginTotal = 0;
  // --------------------------------------------------------------------------
  String messageFromAI = 'membuat ringkasan dengan AI ...';

  /// 📅 Function to Pick Date Range
  Future<void> pickDate() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      helpText: 'Pilih Tanggal Laporan',
      saveText: 'Simpan',
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: GLOBAL.appLogoColor, // Selected date circle color
              onPrimary: Colors.white, // Selected date text color
              onSurface: Colors.black, // Unselected date text color
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.orange.withOpacity(0.3), // background
              foregroundColor: Colors.orange, // Change text/icon color
            ),
            // For the range selection, you might also tweak the date picker theme:
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: Colors.orange.withOpacity(0.3),
              // Color for the block between start and end dates
              // Optionally you can also tweak other properties
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      int selectedDays = picked.end.difference(picked.start).inDays;

      if (selectedDays > 31) {
        // ❌ Show warning if selection is more than 31 days
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You can only select up to 31 days."),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // ✅ Update only if within the allowed range
        startDate = picked.start;
        endDate = picked.end;
        calculateTotals();
        setState(() {});
      }
    }
  }

  Future<void> getFirebaseData() async {
    // listViewer = await LibraryFirebase.getViewers();
    // listUser = await LibraryFirebase.getUsers();
    // listSales = await LibraryFirebase.getSales();
    // listProduct = await LibraryFirebase.getProduct();
    // listTransaction = await LibraryFirebase.getTransactions();
    calculateTotals();
    isInitDone = true;
    setState(() {});
    callAI();
  }

  Future<void> callAI() async {
    String aiText = await callAIsAPI();
    for (var user in listUser) {
      aiText = aiText.replaceAll(user.uid!, user.name!);
      aiText = aiText.replaceAll(
          user.uid![0].toUpperCase() + user.uid!.substring(1), user.name!);
    }
    for (var user in listSales) {
      aiText = aiText.replaceAll(user.sid!, user.name!);
      aiText = aiText.replaceAll(
          user.sid![0].toUpperCase() + user.sid!.substring(1), user.name!);
    }
    messageFromAI = '';
    for (int i = 0; i < aiText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 5)); // Adjust speed
      setState(() {
        messageFromAI += aiText[i];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFirebaseData();
  }

  void calculateTotals() {
    inDateTransactions = listTransaction
        .where((t) =>
            t.date!.isBefore(endDate.add(const Duration(days: 1))) &&
            t.date!.isAfter(startDate.subtract(const Duration(days: 1))))
        .toList();

    transactionCount = inDateTransactions.length;
    viewerCount = listViewer.length;
    customerCount =
        inDateTransactions.map((t) => t.uid).toList().toSet().length;
    productCount = listProduct
        .map((p) => p.stock!)
        .fold(0, (sum, element) => sum + element);
    soldCount = inDateTransactions
        .map((t) => t.purchase!
            .map((p) => p.quantity!)
            .fold(0, (sum, element) => sum + element))
        .toList()
        .fold(0, (sum, element) => sum + element);
    // ----------------------------------------------------------------------
    sellingTotal = inDateTransactions
        .map((t) => t.purchase!
            .map((p) =>
                p.quantity! *
                listProduct.firstWhere((prd) => prd.id! == p.id!).price!)
            .fold(0, (sum, price) => sum + price))
        .toList()
        .fold(0, (sum, element) => sum + element);
    creditTotal = sellingTotal;
    double costTotal = inDateTransactions
        .map((t) => t.purchase!
            .map((p) =>
                p.quantity! *
                listProduct.firstWhere((prd) => prd.id! == p.id!).cost!)
            .fold(0, (sum, cost) => sum + cost))
        .toList()
        .fold(0, (sum, element) => sum + element);
    marginTotal = sellingTotal - costTotal;
    // ----------------------------------------------------------------------
    dates = List.generate(
      endDate.difference(startDate).inDays + 1,
      (index) => startDate.add(Duration(days: index)),
    );
    selectedGraphIndex = dates.length ~/ 3;
    dailyTransactions = List.generate(dates.length, (index) {
      DateTime currentDate = dates[index];

      return inDateTransactions
          .where((t) => t.date?.day == currentDate.day)
          .expand((t) => t.purchase ?? <PurchaseModel>[])
          .map((p) {
        double price =
            listProduct.firstWhere((prd) => prd.id == p.id).price!.toDouble();
        return p.quantity! * price;
      }).fold(0, (sum, price) => sum + price);
    });
  }

  goToRanking() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => RankingScreen(
                  dates: List.generate(
                    endDate.difference(startDate).inDays + 1,
                    (index) => startDate.add(Duration(days: index)),
                  ),
                  listSales: listSales,
                  listUser: listUser,
                  listProduct: listProduct,
                  listTransaction: inDateTransactions,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
          backgroundColor: GLOBAL.appLogoColor,
          centerTitle: true,
          title: const Text('Laporan Penjualan'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                )),
          ],
        ),
        backgroundColor: GLOBAL.appBackgroundColor,
        body: !isInitDone
            ? const Center(
                child: LinearProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipPath(
                          clipper: BottomConvexClipper(),
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            color:
                                GLOBAL.appLogoColor, // Change color as needed
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: MediaQuery.of(context).size.width * 0.05),
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              GLOBAL.imageHeadDecor,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    'Laporan tanggal ${startDate.day} ${monthNamesIndonesian[startDate.month - 1].substring(0, 3)} - ${endDate.day} ${monthNamesIndonesian[endDate.month - 1].substring(0, 3)} ${startDate.year}'),
                              ),
                              IconButton(
                                onPressed: pickDate,
                                icon: const Row(
                                  children: [
                                    Text('Ubah'),
                                    SizedBox(width: 5),
                                    Icon(Icons.calendar_month_rounded,
                                        color: Colors.black, size: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: dailyGraph(),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () {},
                            style: IdeeynButtonStyle.custom(
                                border: BorderSide.none),
                            child: Container(
                              height: 90,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Row(
                                children: [
                                  Image.asset(GLOBAL.imageGraph),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Total Penjualan',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${IdeeynCurrencyString.numberToStringIndonesian(sellingTotal).split(',').first}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: Image.asset(GLOBAL.imageGraphFiller),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: resumeCard(
                                  imagePath: GLOBAL.imageCart,
                                  achievement: '$transactionCount',
                                  description: 'Transaksi',
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: resumeCard(
                                  imagePath: GLOBAL.imagePerson,
                                  achievement: '$customerCount/$viewerCount',
                                  description: 'Pelanggan',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: resumeCard(
                                  imagePath: GLOBAL.imageCredit,
                                  achievement: '$soldCount/$productCount',
                                  description: 'Produk Terjual',
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: resumeCard(
                                  imagePath: GLOBAL.imageFund,
                                  achievement: IdeeynCurrencyString
                                          .numberToStringIndonesian(creditTotal)
                                      .split(',')
                                      .first,
                                  description: 'Piutang Penjualan',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: resumeCard(
                                  imagePath: GLOBAL.imageMoney,
                                  achievement: IdeeynCurrencyString
                                          .numberToStringIndonesian(marginTotal)
                                      .split(',')
                                      .first,
                                  description: 'Laba Penjualan',
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: goToRanking,
                                  style: IdeeynButtonStyle.custom(
                                      border: BorderSide.none),
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 20),
                                    child: Row(
                                      children: [
                                        Image.asset(GLOBAL.imageTrade),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  'Ranking\nPenjualan',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Ringkasan dari AI',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange.shade50,
                            ),
                            child: Text(
                              messageFromAI,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${GLOBAL.APP_NAME} version ${GLOBAL.CURRENT_VERSION}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  ElevatedButton resumeCard(
      {required String imagePath,
      required String achievement,
      required String description}) {
    return ElevatedButton(
      onPressed: () {},
      style: IdeeynButtonStyle.custom(border: BorderSide.none),
      child: Container(
        height: 80,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Image.asset(imagePath),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    achievement,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      description,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container dailyGraph() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 0.5)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.white,
                clipData: const FlClipData.vertical(),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                maxY: dailyTransactions.reduce((a, b) => a > b ? a : b) * 1.1,
                minY: dailyTransactions.reduce((a, b) => a > b ? a : b) * -0.1,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                        dates.length,
                        (index) =>
                            FlSpot(index.toDouble(), dailyTransactions[index])),
                    color: Colors.blue,
                    barWidth: 1,
                    isCurved: true,
                    isStrokeCapRound: true,
                    belowBarData:
                        BarAreaData(show: true, color: Colors.green.shade50),
                    dotData: FlDotData(
                      show: true, // Always show dots
                      getDotPainter: (spot, percent, barData, index) {
                        bool isSelected = selectedGraphIndex == index;
                        return FlDotCirclePainter(
                          radius:
                              isSelected ? 6 : 2, // Bigger dot when selected
                          color: isSelected ? GLOBAL.appLogoColor : Colors.blue,
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
                                    'Tanggal ${dates[spot.x.toInt()].day} ${monthNamesIndonesian[dates[spot.x.toInt()].month - 1].substring(0, 3)}',
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
                    y: listTransaction
                        .where(
                            (t) => t.date?.day == dates[selectedGraphIndex].day)
                        .expand((t) => t.purchase ?? <PurchaseModel>[])
                        .map((p) {
                      double price = listProduct
                          .firstWhere((prd) => prd.id == p.id)
                          .price!
                          .toDouble();
                      return p.quantity! * price;
                    }).fold(0, (sum, price) => sum + price),
                    color: Colors.orange.shade600,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ]),
              ),
            ),
          ),
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(10)),
              color: Colors.green.shade50,
            ),
          ),
        ],
      ),
    );
  }
}
