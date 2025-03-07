import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/firebase/firebase.dart';
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

  pickDate() => null;

  Future<void> getFirebaseData() async {
    listViewer = await LibraryFirebase.getViewers();
    listUser = await LibraryFirebase.getUsers();
    listProduct = await LibraryFirebase.getProduct();
    listTransaction = await LibraryFirebase.getTransactions();
    isInitDone = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFirebaseData();
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: !isInitDone
              ? const Center(
                  child: LinearProgressIndicator(),
                )
              : Column(
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
                    ElevatedButton(
                      onPressed: () {},
                      style: IdeeynButtonStyle.custom(),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Image.asset(name)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 100),
                    Text(listUser[0].name ?? ''),
                    Text(listViewer[0]),
                    Text(listProduct[0].name ?? ''),
                    Text(listTransaction[0].city ?? ''),
                  ],
                ),
        ));
  }
}
