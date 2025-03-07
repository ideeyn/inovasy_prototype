import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/firebase/firebase.dart';
import 'package:inovasy_prototype/global/function/string_formatter.dart';
import 'package:inovasy_prototype/global/style/buttonstyle.dart';
import 'package:inovasy_prototype/models/date_names.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late List<String> listViewer;
  late List<UserModel> listUser;
  late List<ProductModel> listProduct;
  late List<TransactionModel> listTransaction;
  bool isInitDone = false;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime endDate = DateTime.now();
  // --------------------------------------------------------------------------
  double sellingTotal = 0;
  int transactionCount = 0;
  int customerCount = 0;
  int viewerCount = 0;
  int soldCount = 0;
  int productCount = 0;
  double creditTotal = 0;
  double marginTotal = 0;

  pickDate() => null;

  Future<void> getFirebaseData() async {
    listViewer = await LibraryFirebase.getViewers();
    listUser = await LibraryFirebase.getUsers();
    listProduct = await LibraryFirebase.getProduct();
    listTransaction = await LibraryFirebase.getTransactions();
    calculateTotals();
    isInitDone = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFirebaseData();
  }

  void calculateTotals() {
    List<TransactionModel> inDateTransactions = listTransaction
        .where((t) =>
            DateTime.parse(t.date!)
                .isBefore(endDate.add(const Duration(days: 1))) &&
            DateTime.parse(t.date!)
                .isAfter(startDate.subtract(const Duration(days: 1))))
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: !isInitDone
              ? const Center(
                  child: LinearProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                'Laporan tanggal ${startDate.day}-${endDate.day} ${monthNamesIndonesian[startDate.month - 1]} ${startDate.year}'),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {},
                        style:
                            IdeeynButtonStyle.custom(border: BorderSide.none),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Penjualan',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${IdeeynCurrencyString.numberToStringIndonesian(sellingTotal).split(',').first}',
                                      style: const TextStyle(
                                        color: Colors.black,
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
                      const SizedBox(height: 10),
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
                              achievement:
                                  IdeeynCurrencyString.numberToStringIndonesian(
                                          creditTotal)
                                      .split(',')
                                      .first,
                              description: 'Piutang Penjualan',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: resumeCard(
                              imagePath: GLOBAL.imageMoney,
                              achievement:
                                  IdeeynCurrencyString.numberToStringIndonesian(
                                          marginTotal)
                                      .split(',')
                                      .first,
                              description: 'Laba Penjualan',
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Spacer(flex: 2),
                        ],
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
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
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
}
