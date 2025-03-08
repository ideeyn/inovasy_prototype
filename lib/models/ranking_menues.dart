enum RankingMenu { product, customer, sales, city }

extension AA on RankingMenu {
  String get name {
    switch (this) {
      case RankingMenu.product:
        return "PRODUK";
      case RankingMenu.customer:
        return "PELANGGAN";
      case RankingMenu.sales:
        return "SALES";
      case RankingMenu.city:
        return "KABUPATEN";
    }
  }
}
