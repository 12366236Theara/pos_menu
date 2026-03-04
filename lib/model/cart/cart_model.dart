import 'package:pos_menu/model/ingredeint/item_model.dart';

// generate me a CartModel which consist of item and quantity
class Cart {
  final Item item;
  int quantity;

  Cart({required this.item, required this.quantity});

  // to string
  @override
  String toString() {
    return 'Cart{item: $item, quantity: $quantity}';
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {'ITEM': item.toJson(), 'QUANTITY': quantity};
  }

  static List<Cart> fromList(List<Map<String, dynamic>> list) {
    return list.map((item) {
      return Cart(
        item: Item(
          itemCode: item['ITEM_CODE'].toString(),
          itemDesc: item['ITEM_DESC'],
          itemPrice1: item['ITEM_PRICE1'],
          itemBcode: item['ITEM_BCODE'].toString(),
          itemImg: item['ITEM_IMG'].toString(),
        ),
        quantity: item['quantity'],
      );
    }).toList();
  }

  static List<Cart> fromJson(List<dynamic> list) {
    return list.map((item) {
      return Cart(
        item: Item(
          itemCode: item['ITEM_CODE'].toString(),
          itemDesc: item['ITEM_DESC'],
          itemPrice1: double.tryParse(item['ITEM_PRICE1'].toString()) ?? 0,
          itemBcode: item['ITEM_BCODE'].toString(),
          itemImg: item['ITEM_IMG'].toString(),
          physical: (item['PHYSICAL']),
        ),
        quantity: int.tryParse(item['quantity']) ?? 0,
      );
    }).toList();
  }

  Map<String, dynamic> toCheckStockBody(List<Cart> carts) {
    return {
      "items": carts.map((cart) {
        return {"ITEM_CODE": cart.item.itemCode, "quantity": cart.quantity.toString()};
      }).toList(),
    };
  }
}

// from List
