import 'package:flutter/material.dart';
import 'package:inovasy_prototype/APP_GLOBAL.dart';
import 'package:inovasy_prototype/models/product_model/product_model.dart';
import 'package:inovasy_prototype/models/ranking_menues.dart';
import 'package:inovasy_prototype/models/ranking_model.dart';
import 'package:inovasy_prototype/models/sales_model/sales_model.dart';
import 'package:inovasy_prototype/models/transaction_model/purchase_model.dart';
import 'package:inovasy_prototype/models/transaction_model/transaction_model.dart';
import 'package:inovasy_prototype/models/user_model/user_model.dart';
import 'package:inovasy_prototype/screens/index/report/ranking/widget_ranking/appbar_ranking.dart';
import 'package:inovasy_prototype/screens/index/report/ranking/widget_ranking/chart_ranking.dart';
import 'package:inovasy_prototype/screens/index/report/ranking/widget_ranking/draggable_modal.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen(
      {super.key,
      required this.listSales,
      required this.listUser,
      required this.listProduct,
      required this.listTransaction,
      required this.dates});

  final List<SalesModel> listSales;
  final List<UserModel> listUser;
  final List<ProductModel> listProduct;
  final List<TransactionModel> listTransaction;
  final List<DateTime> dates;

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late int selectedGraphIndex = widget.dates.length ~/ 3;
  late List<double> dailyProduct;
  late List<double> dailyCustomer;
  late List<double> dailySales;
  late List<double> dailyCity;
  late List<RankingTableModel> tableData;
  RankingMenu selectedMenu = RankingMenu.product;

  @override
  void initState() {
    super.initState();
    calculateGraph();
    changeMenu(selectedMenu);
  }

  List<double> getListForMenu(RankingMenu menu) {
    if (menu == RankingMenu.customer) return dailyCustomer;
    if (menu == RankingMenu.sales) return dailySales;
    if (menu == RankingMenu.city) return dailyCity;
    return dailyProduct;
  }

  changeMenu(RankingMenu menu) {
    selectedMenu = menu;
    if (menu == RankingMenu.product) {
      tableData = widget.listTransaction
          .expand((t) => t.purchase!)
          .fold<Map<String, RankingTableModel>>({}, (map, p) {
            var product = widget.listProduct.firstWhere((lp) => lp.id == p.id!);
            map.update(
              product.name!,
              (existing) => RankingTableModel(
                name: existing.name,
                count: existing.count! + p.quantity!,
                price: (product.price! * (existing.count! + p.quantity!))
                    .toDouble(),
              ),
              ifAbsent: () => RankingTableModel(
                name: product.name,
                count: p.quantity,
                price: (product.price! * p.quantity!).toDouble(),
              ),
            );
            return map;
          })
          .values
          .toList();
    }
    if (menu == RankingMenu.customer) {
      tableData = widget.listTransaction
          .fold<Map<String, RankingTableModel>>({}, (map, t) {
            // Unique identifier for the transaction owner
            String uid = t.uid!;

            // Calculate total price for this transaction from all its purchases
            double transactionTotal = t.purchase!.fold<double>(0, (sum, p) {
              var product =
                  widget.listProduct.firstWhere((lp) => lp.id == p.id!);
              return sum + (p.quantity! * product.price!);
            });

            // Update our map: if the UID exists, increment count and add to the price;
            // otherwise, create a new RankingTableModel for this UID.
            map.update(
              uid,
              (existing) => RankingTableModel(
                name: uid,
                count: existing.count! + 1,
                price: existing.price! + transactionTotal,
              ),
              ifAbsent: () => RankingTableModel(
                name: uid,
                count: 1,
                price: transactionTotal,
              ),
            );

            return map;
          })
          .values
          .map((d) => RankingTableModel(
              name: widget.listUser.firstWhere((u) => u.uid! == d.name!).name,
              count: d.count,
              price: d.price))
          .toList();
    }
    if (menu == RankingMenu.sales) {
      tableData = widget.listTransaction
          .fold<Map<String, RankingTableModel>>({}, (map, t) {
            // Unique identifier for the transaction owner
            String sales = t.sales!;

            // Calculate total price for this transaction from all its purchases
            double transactionTotal = t.purchase!.fold<double>(0, (sum, p) {
              var product =
                  widget.listProduct.firstWhere((lp) => lp.id == p.id!);
              return sum + (p.quantity! * product.price!);
            });

            // Update our map: if the sales exists, increment count and add to the price;
            // otherwise, create a new RankingTableModel for this sales.
            map.update(
              sales,
              (existing) => RankingTableModel(
                name: sales,
                count: existing.count! + 1,
                price: existing.price! + transactionTotal,
              ),
              ifAbsent: () => RankingTableModel(
                name: sales,
                count: 1,
                price: transactionTotal,
              ),
            );

            return map;
          })
          .values
          .map((d) => RankingTableModel(
              name: widget.listSales.firstWhere((u) => u.sid! == d.name!).name,
              count: d.count,
              price: d.price))
          .toList();
    }
    if (menu == RankingMenu.city) {
      tableData = widget.listTransaction
          .fold<Map<String, RankingTableModel>>({}, (map, t) {
            // Unique identifier for the transaction owner
            String city = t.city!;

            // Calculate total price for this transaction from all its purchases
            double transactionTotal = t.purchase!.fold<double>(0, (sum, p) {
              var product =
                  widget.listProduct.firstWhere((lp) => lp.id == p.id!);
              return sum + (p.quantity! * product.price!);
            });

            // Update our map: if the UID exists, increment count and add to the price;
            // otherwise, create a new RankingTableModel for this UID.
            map.update(
              city,
              (existing) => RankingTableModel(
                name: city,
                count: existing.count! + 1,
                price: existing.price! + transactionTotal,
              ),
              ifAbsent: () => RankingTableModel(
                name: city,
                count: 1,
                price: transactionTotal,
              ),
            );

            return map;
          })
          .values
          .toList();
    }
    setState(() {});
  }

  calculateGraph() {
    dailyProduct = List.generate(
        widget.dates.length,
        (index) => widget.listTransaction
            .where((t) => t.date?.day == widget.dates[index].day)
            .expand((t) => t.purchase ?? <PurchaseModel>[])
            .map((p) => p.quantity!)
            .fold(0, (sum, current) => sum + current));
    dailyCustomer = List.generate(
        widget.dates.length,
        (index) => widget.listTransaction
            .where((t) => t.date?.day == widget.dates[index].day)
            .map((p) => p.uid!)
            .toSet()
            .length
            .toDouble());
    dailySales = List.generate(
        widget.dates.length,
        (index) => widget.listTransaction
            .where((t) => t.date?.day == widget.dates[index].day)
            .length
            .toDouble());
    dailyCity = List.generate(
        widget.dates.length,
        (index) => widget.listTransaction
            .where((t) => t.date?.day == widget.dates[index].day)
            .map((p) => p.city!)
            .toSet()
            .length
            .toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RankingAppbar(
        backgroundColor: GLOBAL.appLogoColor,
        contentColor: Colors.white,
      ),
      backgroundColor: GLOBAL.appLogoColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: screenHeader(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: RankingChart(
                    chartDates: widget.dates,
                    chartValues: getListForMenu(selectedMenu),
                    selectedMenuName: selectedMenu.name),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    menuBox(RankingMenu.product),
                    menuBox(RankingMenu.customer),
                    menuBox(RankingMenu.sales),
                    menuBox(RankingMenu.city),
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
              return DraggableModal(
                scrollController: scrollController,
                selectedMenu: selectedMenu,
                tableData: tableData
                  ..sort((a, b) => b.price!.compareTo(a.price!)),
              );
            },
          ),
        ],
      ),
    );
  }

  //!##########################################################################

  Column screenHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ranking',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        Text('Berdasarkan total penjualan',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ],
    );
  }

  GestureDetector menuBox(RankingMenu menu) {
    bool isSelected = menu == selectedMenu;

    return GestureDetector(
        onTap: () => changeMenu(menu),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? Colors.white : null,
          ),
          child: Text(
            menu.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ));
  }
}
