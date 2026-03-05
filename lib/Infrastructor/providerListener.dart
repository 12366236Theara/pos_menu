import 'package:flutter/cupertino.dart';
import 'package:pos_menu/model/ingredeint/ingredient_model.dart';
import 'package:pos_menu/model/menu/menu_option_model.dart';

class ProviderListener with ChangeNotifier {
  bool? enabltem;
  bool? enabledDashboardItem;
  bool? enabledDashboardNewStockItem = true;

  double? progress = 0;

  double? totalProgress = 1;

  int allItemInSaleCartQty = 0;
  int countItem = 0;
  double saleforedisPrice = 0;
  double orderBeforedisPrice = 0;
  double saleTotalPrice = 0.0;

  // List<SaleCartModel> saleCartItems = [];
  Map<Ingredient, int> saleCartIngredient = {};

  var totalSplitPrice = 0.0;
  var oldPrice = 0.0;

  double calculateOptChoicePrice(List<MenuOption>? options) {
    if (options == null) return 0;

    double total = 0;

    for (var opt in options) {
      final choices = opt.optChoices ?? [];
      for (var choice in choices) {
        if (choice.isSelected == true) {
          total += (choice.price ?? 0);
        }
      }
    }

    return total;
  }

  void saleOrderRefresh() {
    notifyListeners();
  }

  void onlineUserRefresh() {
    notifyListeners();
  }

  void analysisMasterRefresh() {
    notifyListeners();
  }

  void setEnabledDashboardItem(bool value) {
    enabledDashboardItem = value;
    notifyListeners();
  }

  void setEnabledDashboardNewStockItem(bool value) {
    enabledDashboardNewStockItem = value;
    notifyListeners();
  }

  void updateProgress(double progress, double totalProgress) {
    this.progress = progress;
    this.totalProgress = totalProgress;
    notifyListeners();
  }
}
