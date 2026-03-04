import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_menu/Infrastructor/singleton.dart';
import 'package:pos_menu/model/cart/salecart_model.dart';
import 'package:pos_menu/model/ingredeint/ingredient_model.dart';
import 'package:pos_menu/model/menu/menu_model.dart';
import 'package:pos_menu/model/menu/menu_option_model.dart';
import 'dart:developer';

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

  List<SaleCartModel> saleCartItems = [];
  Map<Ingredient, int> saleCartIngredient = {};

  var totalSplitPrice = 0.0;
  var oldPrice = 0.0;

  void setDiscountSplit(BuildContext context, double? discountPercentController, double? discountDollarController) {
    oldPrice = saleCartItems.fold(0.0, (sum, item) => sum + (item.unitPrice * item.orderCount));

    totalSplitPrice = oldPrice;
  }

  int getItemQty(MenuModel item) {
    for (int i = 0; i < saleCartItems.length; i++) {
      if (saleCartItems[i].menu.itemCode == item.itemCode) {
        return saleCartItems[i].orderCount.toInt();
      }
    }
    return 0;
  }

  void removeCartOrder(String itemCode) {
    // Debug logging
    log("Attempting to remove item: $itemCode");
    log("Cart before removal: ${saleCartItems.length} items, total qty: $allItemInSaleCartQty");

    // Find all items with matching itemCode (there might be multiple with different options)
    final itemsToRemove = saleCartItems.where((item) => item.menu.itemCode == itemCode).toList();

    if (itemsToRemove.isEmpty) {
      log("No items found with code: $itemCode");
      return;
    }

    // Calculate total quantity to remove
    int totalQtyToRemove = 0;
    for (var item in itemsToRemove) {
      totalQtyToRemove += item.orderCount.toInt();

      // Remove from ingredients
      for (final req in item.menu.getMenuOptionIngredients()) {
        final int base = req.qty?.toInt() ?? 0;
        if (base == 0) continue;

        final int delta = (base * item.orderCount.toInt()).toInt();
        saleCartIngredient.update(req, (prev) => prev - delta, ifAbsent: () => 0);

        if (saleCartIngredient[req]! <= 0) {
          saleCartIngredient.remove(req);
        }
      }
    }

    // Remove items from cart
    saleCartItems.removeWhere((item) => item.menu.itemCode == itemCode);

    // Update cart counts
    allItemInSaleCartQty -= totalQtyToRemove;
    countItem = allItemInSaleCartQty;

    // Recalculate price
    calculateSaleTotalPrice(0.0);

    log("Removed $totalQtyToRemove items, cart after: ${saleCartItems.length} items, total qty: $allItemInSaleCartQty");

    notifyListeners();
  }

  void addToSaleCartList(List<SaleCartModel?> items) async {
    for (var item in items) {
      addToSaleCart(
        item?.menu ?? MenuModel(itemCode: ""),
        item?.orderCount.toInt() ?? 0,
        addcart: false,
        cookingStatus: item?.menu.cookingStatus ?? 0,
        queue: item?.menu.queue ?? -1,
      );
    }
    calculateSaleTotalPrice(0);
    notifyListeners();
  }

  void removeCartItemByIndex(int index) {
    if (index < 0 || index >= saleCartItems.length) {
      log("Invalid index for removal: $index");
      return;
    }

    final removedItem = saleCartItems[index];
    final removedQty = removedItem.orderCount.toInt();

    log("Removing item at index $index: ${removedItem.menu.itemCode}, qty: $removedQty");

    // Update ingredient totals
    for (final req in removedItem.menu.getMenuOptionIngredients()) {
      final int base = req.qty?.toInt() ?? 0;
      if (base == 0) continue;

      final int delta = (base * removedQty).toInt();
      saleCartIngredient.update(req, (prev) => prev - delta, ifAbsent: () => 0);

      if (saleCartIngredient[req]! <= 0) {
        saleCartIngredient.remove(req);
      }
    }

    // Remove from cart
    saleCartItems.removeAt(index);

    // Update counts
    allItemInSaleCartQty -= removedQty;
    countItem = allItemInSaleCartQty;

    // Recalculate price
    calculateSaleTotalPrice(0.0);

    log("Cart after removal: ${saleCartItems.length} items, total qty: $allItemInSaleCartQty");

    notifyListeners();
  }

  void debugCartState(String context) {
    log("=== CART DEBUG: $context ===");
    log("Items count: ${saleCartItems.length}");
    log("Total quantity: $allItemInSaleCartQty");
    log("Sale total price: $saleTotalPrice");

    for (int i = 0; i < saleCartItems.length; i++) {
      final item = saleCartItems[i];
      log("  [$i] ${item.menu.itemCode} - ${item.menu.itemDesc}");
      log("      Qty: ${item.orderCount}, Price: ${item.menu.itemPrice}");
    }
    log("=============================");
  }

  void updateCartItemPrice(int index, double newPrice) {
    if (index >= 0 && index < saleCartItems.length) {
      saleCartItems[index].menu.itemPrice = newPrice;
      calculateSaleTotalPrice(0);
      //
      notifyListeners();
    }
  }

  void updateCartItemPriceTextfeil(int idx, double newPrice) {
    if (idx >= 0 && idx < saleCartItems.length) {
      saleCartItems[idx].menu.itemPrice = newPrice;
    }
    saleTotalPrice = saleCartItems.fold(0.0, (sum, item) => sum + ((item.menu.itemPrice ?? 0.0) * item.orderCount));
    notifyListeners();
  }

  void clearCart() {
    saleCartItems.clear();
    saleCartIngredient.clear();
    allItemInSaleCartQty = 0;
    orderBeforedisPrice = 0;
    saleforedisPrice = 0;
    saleTotalPrice = 0;
    notifyListeners();
  }

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

  void addToSaleCart(MenuModel incoming, int qty, {bool isUpdate = false, int cookingStatus = 0, int queue = -1, required bool addcart}) async {
    final frozenMenuOpts = cloneMenuOpts(incoming.menuOpts);
    final configKey = buildConfigKey(incoming.itemCode, incoming.cookingStatus.toString(), "$queue", incoming.menuOpts);

    for (int i = 0; i < saleCartItems.length; i++) {
      final existing = saleCartItems[i];

      if (isUpdate) {
        saleCartItems[i].orderCount = qty;

        calculateSaleTotalPrice(0);
        notifyListeners();
        return;
      }

      if (existing.menu.configKey == configKey) {
        final delta = isUpdate ? (qty - existing.orderCount) : qty;
        final newQty = isUpdate ? qty : existing.orderCount + qty;

        if (newQty <= 0) {
          allItemInSaleCartQty -= existing.orderCount.toInt();
          saleCartItems.removeAt(i);
        } else {
          existing.orderCount = newQty;
          allItemInSaleCartQty += delta.toInt();
        }

        calculateSaleTotalPrice(0);
        _updateIngredientTotalsForItem(incoming, delta.toInt());
        countItem = allItemInSaleCartQty;
        notifyListeners();
        return;
      }
    }

    // NEW ITEM
    final MenuModel frozenMenu = incoming.copyWith(
      menuOpts: frozenMenuOpts,
      configKey: configKey,
      cookingStatus: cookingStatus,
      itemStorePrice: incoming.itemPrice?.toDouble(),
      queue: queue,
    );

    saleCartItems.insert(0, SaleCartModel(menu: frozenMenu, orderCount: qty));

    allItemInSaleCartQty += qty.toInt();

    calculateSaleTotalPrice(0);
    _updateIngredientTotalsForItem(incoming, qty);
    countItem = allItemInSaleCartQty;
    notifyListeners();
  }

  void _updateIngredientTotalsForItem(MenuModel item, int qtyDelta) {
    for (final req in item.getMenuOptionIngredients()) {
      final int base = req.qty?.toInt() ?? 0;
      if (base == 0) continue;

      final int delta = (base * qtyDelta).toInt();

      saleCartIngredient.update(req, (prev) => prev + delta, ifAbsent: () => delta);

      if (saleCartIngredient[req]! <= 0) {
        saleCartIngredient.remove(req);
      }
    }
  }

  // void addToSaleCartList(List<SaleCartModel?> items) async {
  //   for (var item in items) {

  //     addToSaleCart(item?.menu ?? MenuModel(itemCode: ""), item?.orderCount.toInt() ?? 0,
  //         addcart: false, cookingStatus: item?.menu.cookingStatus ?? 0, queue: item?.menu.queue ?? -1);
  //   }
  //   calculateSaleTotalPrice(0);
  //   notifyListeners();
  // }

  void calculateSaleTotalPrice(double discountPrice) {
    saleforedisPrice = 0;
    for (var cart in saleCartItems) {
      saleforedisPrice += (cart.menu.itemPrice ?? 0) * cart.orderCount;
    }
    saleTotalPrice = saleforedisPrice - discountPrice;
  }

  // void calculateTotalPrice(double discountPrice) {
  //   orderBeforedisPrice = 0;
  //   for (var cart in orderCartItems) {
  //     double priceToUse = cart.item.itemSuppCost ?? cart.item.itemDcost ?? 0;
  //     orderBeforedisPrice += priceToUse * cart.quantity;
  //   }
  //   poTotalPrice = orderBeforedisPrice - discountPrice;
  // }

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

  Future<List<Map<String, dynamic>>> loadAllCarts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'saleCartList';

      final existingString = prefs.getString(key);
      if (existingString == null) {
        log("No saleCartList found in SharedPreferences.");
        return [];
      }

      final decodedJson = json.decode(existingString);
      if (decodedJson is! List) {
        log("Unexpected JSON structure for saleCartList.");
        return [];
      }
      List<Map<String, dynamic>> savedCarts = decodedJson.map((cartJson) {
        if (cartJson is Map<String, dynamic>) {
          return cartJson;
        } else {
          throw Exception("Invalid cart format.");
        }
      }).toList();

      notifyListeners();
      return savedCarts;
    } catch (e, st) {
      log("Error loading saleCartList JSON: $e\n$st");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getSaleCacheById(String cartId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'saleCartList';
      final existingString = prefs.getString(key);
      if (existingString == null) {
        log("No saleCartList found.");
        return null;
      }
      List<dynamic> savedCarts = json.decode(existingString) as List<dynamic>;
      Map<String, dynamic>? cart = savedCarts.firstWhere((cart) => cart["id"] == cartId, orElse: () => null);
      if (cart != null) {
        log("Loaded cart with id=$cartId");
      } else {
        log("No cart found with id=$cartId");
      }

      return cart;
    } catch (e, st) {
      log("Error fetching cart with id=$cartId: $e\n$st");
      return null;
    }
  }

  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();
    return "$day-$month-$year";
  }
}
