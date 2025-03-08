import 'package:flutter/material.dart';
import 'package:inovasy_prototype/global/function/string_formatter.dart';
import 'package:inovasy_prototype/models/ranking_menues.dart';
import 'package:inovasy_prototype/models/ranking_model.dart';

class DraggableModal extends StatelessWidget {
  const DraggableModal({
    super.key,
    required this.scrollController,
    required this.selectedMenu,
    required this.tableData,
  });

  final ScrollController scrollController;
  final RankingMenu selectedMenu;
  final List<RankingTableModel> tableData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "${selectedMenu.name[0]}${selectedMenu.name.substring(1).toLowerCase()} Tertinggi",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  const Text("Berdasarkan Total Penjualan",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  // const SizedBox(height: 10),
                  const Divider(),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: Text('Nama')),
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(selectedMenu == RankingMenu.product
                              ? "Terjual"
                              : "Transaksi"),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: const Text("Total (Rp)"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(tableData.length, (index) {
              return Container(
                color: index.isEven ? Colors.orange.shade50 : Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text(tableData[index].name ?? '')),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text((tableData[index].count!).toString()),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(IdeeynCurrencyString.numberToStringIndonesian(
                              (tableData[index].price!).toDouble())
                          .split(',')[0]),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
