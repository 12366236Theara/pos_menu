// import 'package:pos_menu/model/ingredeint/ingredient_model.dart';
// import 'package:pos_menu/model/menu/menu_model.dart';
// import 'package:pos_menu/model/menu/menu_option_model.dart';
// import 'package:pos_menu/model/menu/option_choices_model.dart';

// class SaleCartModel {
//   final MenuModel menu;
//   num orderCount;
//   double discountOnInvoice;
//   double percentOnInvoice;

//   SaleCartModel({required this.menu, required this.orderCount, this.discountOnInvoice = 0.0, this.percentOnInvoice = 0.0});

//   @override
//   String toString() {
//     return 'SaleCartModel{item: $menu, quantity: $orderCount}';
//   }

//   List<OptChoice> get selectedChoices =>
//       menu.menuOpts?.expand((o) => o.optChoices ?? const <OptChoice>[]).where((c) => c.isSelected == true).toList() ?? const <OptChoice>[];

//   double get unitPrice => (menu.itemPrice ?? 0).toDouble();

//   double get lineTotal => unitPrice * orderCount;

//   static List<SaleCartModel> fromList(List<dynamic> list) {
//     return list.map((menu) {
//       return SaleCartModel(
//         menu: MenuModel(
//           itemCode: menu['ITEM_CODE'].toString(),
//           itemBcode: menu['ITEM_BCODE'].toString(),
//           itemDesc: menu['ITEM_DESC'],
//           itemPrice: menu['ITEM_PRICE1'],
//           itemType: menu['ITEM_TYPE'],
//           itemDcost: menu['ITEM_DCOST'],
//           unitStock: menu['UNIT_STOCK'],
//           unitSale: menu['UNIT_SALE'],
//           unitWeight: menu['UNIT_WEIGHT'],
//           itemStat: menu['ITEM_STAT'],
//           transPres: menu['TRANS_PRES'],
//           userCrea: menu['USER_CREA'],
//           userUpdt: menu['USER_UPDT'],
//           userCode: menu['USER_CODE'],
//           catCode: menu['CAT_CODE'],
//           itemImg: menu['ITEM_IMG'],
//           guest: menu['NUM_GUEST'],
//           location: menu['LOCATION'],
//           physical: menu['PHYSICAL'],
//           onOrder: menu['ON_ORDER'],
//           total: menu['TOTAL'],
//           ingredients: menu['INGREDIENTS'] != null ? Ingredient.fromList(menu['INGREDIENTS']) : null,
//           menuOpts: (menu['GROUP_OPTIONS'] != null) ? MenuOption.fromGroupOptions(menu['GROUP_OPTIONS'] ?? []) as List<MenuOption>? : null,
//           configKey: menu['CONFIG_KEY']?.toString(),
//           cookingStatus: int.tryParse(menu['COOKSTATUS'].toString()) ?? 0,
//           queue: int.tryParse(menu['QUEUE'].toString()) ?? 0,
//           createdAt: menu['CREATED_AT'] ?? "",
//         ),
//         orderCount: menu['ORDER_COUNT'],
//         discountOnInvoice: double.tryParse(menu['DISON_INVOICE']?.toString() ?? '0') ?? 0.0, // Initialize discount from JSON
//         percentOnInvoice: double.tryParse(menu["DI_PER_ONINV"]?.toString() ?? '0') ?? 0.0,
//       );
//     }).toList();
//   }

//   static List<SaleCartModel> fromJson(List<dynamic> list) {
//     return list.map((item) {
//       return SaleCartModel(
//         menu: MenuModel(
//           itemCode: item['ITEM_CODE'].toString(),
//           itemDesc: item['ITEM_DESC'],
//           itemPrice: double.tryParse(item['ITEM_PRICE1'].toString()) ?? 0,
//           itemBcode: item['ITEM_BCODE'].toString(),
//           itemImg: item['ITEM_IMG'].toString(),
//           physical: (item['PHYSICAL']),
//           itemType: item['ITEM_TYPE'],
//           itemDcost: item['ITEM_DCOST'],
//           unitStock: item['UNIT_STOCK'],
//           unitSale: item['UNIT_SALE'],
//           unitWeight: item['UNIT_WEIGHT'],
//           itemStat: item['ITEM_STAT'],
//           onOrder: item['ON_ORDER'],
//           total: item['TOTAL'],
//           transPres: item['TRANS_PRES'],
//           userCrea: item['USER_CREA'],
//           userUpdt: item['USER_UPDT'],
//           userCode: item['USER_CODE'],
//           catCode: item['CAT_CODE'],
//         ),
//         orderCount: num.tryParse(item['ORDER_COUNT']) ?? 0,
//         discountOnInvoice: double.tryParse(item["DISON_INVOICE"]?.toString() ?? '0') ?? 0.0,
//         percentOnInvoice: double.tryParse(item['DI_PER_ONINV']?.toString() ?? '0') ?? 0.0,
//       );
//     }).toList();
//   }

//   // toJson
//   Map<String, dynamic> toJson({bool selectedOnly = true}) {
//     final map = menu.toJson(selectedOnly: selectedOnly);

//     map.addAll({'ORDER_COUNT': orderCount, "DISON_INVOICE": discountOnInvoice, "DI_PER_ONINV": percentOnInvoice});

//     return map;
//   }
// }
