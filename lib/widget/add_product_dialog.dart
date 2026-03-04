// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_menu/Infrastructor/providerListener.dart';
// import 'package:pos_menu/model/menu/menu_model.dart';
// import 'package:pos_menu/model/menu/menu_option_model.dart';
// import 'package:pos_menu/model/menu/option_choices_model.dart';
// import 'package:provider/provider.dart';

// // Main Dialog Widget
// class AddProductDialog extends StatelessWidget {
//   final int index;
//   final String itemCode;
//   final MenuModel menu;
//   final String? imageURL;
//   final String? numInStock;
//   final String? cateIndex;
//   final TextEditingController qtyController;
//   final String? currencyCode;

//   const AddProductDialog({
//     super.key,
//     required this.index,
//     required this.itemCode,
//     required this.menu,
//     this.imageURL,
//     this.numInStock,
//     this.cateIndex,
//     required this.qtyController,
//     this.currencyCode = "\$",
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Create a deep copy of the menu
//     final MenuModel menuCopy = menu.copyWith(
//       menuOpts: menu.menuOpts
//           ?.map((opt) => opt.copyWith(optChoices: opt.optChoices?.map((choice) => choice.copyWith(isSelected: false)).toList()))
//           .toList(),
//       ingredients: menu.ingredients?.map((ing) => ing.copyWith()).toList(),
//     );

//     if (qtyController.text.isEmpty) {
//       qtyController.text = '1';
//     }

//     return Dialog(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//       child: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: _DialogContainer(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // HEADER WITH CLOSE BUTTON
//               _DialogHeader(title: 'Customize Your Order', onClose: () => Navigator.pop(context)),

//               // SCROLLABLE CONTENT
//               Flexible(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // PRODUCT HEADER SECTION
//                       ProductHeaderSection(
//                         imageURL: imageURL,
//                         itemDesc: menuCopy.itemDesc,
//                         itemPrice: menuCopy.itemPrice?.toDouble(),
//                         currencyCode: currencyCode ?? '\$',
//                         numInStock: numInStock,
//                       ),

//                       const SizedBox(height: 32),

//                       // OPTIONS SECTION
//                       if (menuCopy.menuOpts != null && menuCopy.menuOpts!.isNotEmpty)
//                         ...menuCopy.menuOpts!.map((menuOpt) => ProductOptionSection(menuOpt: menuOpt, currencyCode: currencyCode ?? '\$')),
//                     ],
//                   ),
//                 ),
//               ),

//               // FOOTER WITH QUANTITY AND ADD TO CART
//               _DialogFooter(menuCopy: menuCopy, qtyController: qtyController, currencyCode: currencyCode ?? '\$'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Dialog Container Widget
// class _DialogContainer extends StatelessWidget {
//   final Widget child;

//   const _DialogContainer({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 900, maxHeight: MediaQuery.of(context).size.height * 0.85),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 20))],
//       ),
//       child: ClipRRect(borderRadius: BorderRadius.circular(24), child: child),
//     );
//   }
// }

// // Dialog Header Widget
// class _DialogHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback onClose;

//   const _DialogHeader({required this.title, required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142), letterSpacing: -0.5),
//             ),
//           ),
//           MouseRegion(
//             cursor: SystemMouseCursors.click,
//             child: GestureDetector(
//               onTap: onClose,
//               child: Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
//                 child: Icon(Icons.close_rounded, size: 20, color: Colors.grey.shade700),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Product Header Section Widget
// class ProductHeaderSection extends StatelessWidget {
//   final String? imageURL;
//   final String? itemDesc;
//   final double? itemPrice;
//   final String currencyCode;
//   final String? numInStock;

//   const ProductHeaderSection({super.key, this.imageURL, this.itemDesc, this.itemPrice, required this.currencyCode, this.numInStock});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.pink.shade50, Colors.purple.shade50]),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.pink.shade100, width: 1),
//       ),
//       child: Row(
//         children: [
//           // Product Image
//           Hero(
//             tag: 'product_$imageURL',
//             child: Container(
//               height: 140,
//               width: 140,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: CachedNetworkImage(
//                   imageUrl: imageURL ?? '',
//                   fit: BoxFit.cover,
//                   errorWidget: (_, __, ___) => Container(
//                     color: Colors.grey.shade100,
//                     child: Icon(Icons.restaurant_menu_rounded, size: 50, color: Colors.grey.shade400),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 24),

//           // Product Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   itemDesc ?? "N/A",
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontFamily: 'Khmer OS Content',
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3142),
//                     height: 1.3,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(colors: [Colors.pink, Colors.pink.shade600]),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
//                   ),
//                   child: Text(
//                     '$currencyCode${itemPrice?.toStringAsFixed(2) ?? "0.00"}',
//                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ),
//                 if (numInStock != null) ...[
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.inventory_2_outlined, size: 16, color: Colors.green.shade700),
//                       const SizedBox(width: 6),
//                       Text(
//                         '$numInStock in stock',
//                         style: TextStyle(fontSize: 13, color: Colors.green.shade700, fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Product Option Section Widget
// class ProductOptionSection extends StatefulWidget {
//   final MenuOption menuOpt;
//   final String currencyCode;

//   const ProductOptionSection({super.key, required this.menuOpt, required this.currencyCode});

//   @override
//   State<ProductOptionSection> createState() => _ProductOptionSectionState();
// }

// class _ProductOptionSectionState extends State<ProductOptionSection> {
//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(
//       builder: (context, setLocal) => Container(
//         margin: const EdgeInsets.only(bottom: 24),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200, width: 1.5),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Option Header
//             Row(
//               children: [
//                 Container(
//                   width: 4,
//                   height: 24,
//                   decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(2)),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     widget.menuOpt.groupName ?? "Option",
//                     style: const TextStyle(fontFamily: 'Khmer OS Content', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
//                   ),
//                 ),
//                 // Required/Optional Badge
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: widget.menuOpt.isMultiselect == true ? Colors.blue.shade50 : Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(color: widget.menuOpt.isMultiselect == true ? Colors.blue.shade200 : Colors.orange.shade200),
//                   ),
//                   child: Text(
//                     widget.menuOpt.isMultiselect == true ? 'Multiple' : 'Choose One',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: widget.menuOpt.isMultiselect == true ? Colors.blue.shade700 : Colors.orange.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Option Choices
//             ...?widget.menuOpt.optChoices?.map((choice) {
//               if (widget.menuOpt.isMultiselect == true) {
//                 // CHECKBOX STYLE
//                 return ModernCheckboxTile(
//                   title: choice.choiceName ?? "N/A",
//                   price: choice.price ?? 0,
//                   currencyCode: widget.currencyCode,
//                   isSelected: choice.isSelected ?? false,
//                   onChanged: (val) => setLocal(() {
//                     choice.isSelected = val ?? false;
//                   }),
//                 );
//               } else {
//                 // RADIO STYLE
//                 return ModernRadioTile(
//                   title: choice.choiceName ?? "N/A",
//                   price: choice.price ?? 0,
//                   currencyCode: widget.currencyCode,
//                   value: choice.choiceCode ?? '',
//                   groupValue: widget.menuOpt.optChoices!.firstWhere((c) => c.isSelected == true, orElse: () => OptChoice()).choiceCode,
//                   onChanged: (val) => setLocal(() {
//                     for (var c in widget.menuOpt.optChoices!) {
//                       c.isSelected = (c.choiceCode == val);
//                     }
//                   }),
//                 );
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Dialog Footer Widget
// class _DialogFooter extends StatefulWidget {
//   final MenuModel menuCopy;
//   final TextEditingController qtyController;
//   final String currencyCode;

//   const _DialogFooter({required this.menuCopy, required this.qtyController, required this.currencyCode});

//   @override
//   State<_DialogFooter> createState() => _DialogFooterState();
// }

// class _DialogFooterState extends State<_DialogFooter> {
//   late final Map<String, bool> ingredientSelection;
//   late final Map<String, TextEditingController> ingredientQtyControllers;

//   @override
//   void initState() {
//     super.initState();
//     ingredientSelection = {for (var ing in widget.menuCopy.ingredients ?? []) ing.ingredientCode ?? '': true};
//     ingredientQtyControllers = {
//       for (var ing in widget.menuCopy.ingredients ?? []) ing.ingredientCode ?? '': TextEditingController(text: ing.qty?.toString() ?? '1'),
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
//       ),
//       child: Column(
//         children: [
//           // Quantity Selector
//           StatefulBuilder(
//             builder: (context, setLocal) {
//               int qty = int.tryParse(widget.qtyController.text) ?? 1;

//               void updateQty(int newQty) {
//                 qty = newQty.clamp(1, 99999);
//                 widget.qtyController.text = qty.toString();
//                 setLocal(() {});
//               }

//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Quantity',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
//                   ),
//                   const SizedBox(width: 24),

//                   // Quantity Controls
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade200, width: 1.5),
//                     ),
//                     child: Row(
//                       children: [
//                         // Decrement
//                         QuantityButton(icon: Icons.remove_rounded, onPressed: () => updateQty(qty - 1), isEnabled: qty > 1),

//                         // Quantity Display
//                         Container(
//                           width: 70,
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           child: Center(
//                             child: Text(
//                               qty.toString(),
//                               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
//                             ),
//                           ),
//                         ),

//                         // Increment
//                         QuantityButton(icon: Icons.add_rounded, onPressed: () => updateQty(qty + 1), isEnabled: true),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),

//           const SizedBox(height: 20),

//           // Add to Cart Button
//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: ElevatedButton(
//               onPressed: () async {
//                 final cartProvider = Provider.of<ProviderListener>(context, listen: false);

//                 final customizedIngredients =
//                     widget.menuCopy.ingredients?.asMap().entries.map((entry) {
//                       final ing = entry.value;
//                       final code = ing.ingredientCode ?? '';
//                       if (!(ingredientSelection[code] ?? true)) {
//                         return ing.copyWith(qty: 0);
//                       }
//                       return ing.copyWith(qty: int.tryParse(ingredientQtyControllers[code]?.text ?? '1') ?? 1);
//                     }).toList() ??
//                     [];

//                 final addonPrice = cartProvider.calculateOptChoicePrice(widget.menuCopy.menuOpts);
//                 final updatedPrice = addonPrice + (widget.menuCopy.itemPrice ?? 0);

//                 final updatedMenu = widget.menuCopy.copyWith(itemPrice: updatedPrice.toDouble(), ingredients: customizedIngredients);

//                 Navigator.pop(context);
//                 cartProvider.addToSaleCart(updatedMenu, int.parse(widget.qtyController.text), addcart: true);
//               },
//               style:
//                   ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pink,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shadowColor: Colors.pink.withOpacity(0.4),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                   ).copyWith(
//                     overlayColor: WidgetStateProperty.resolveWith((states) {
//                       if (states.contains(WidgetState.hovered)) {
//                         return Colors.white.withOpacity(0.1);
//                       }
//                       return null;
//                     }),
//                   ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.shopping_cart_rounded, size: 22),
//                   const SizedBox(width: 12),
//                   Text('Add to Cart', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // MODERN CHECKBOX TILE WIDGET (unchanged)
// class ModernCheckboxTile extends StatefulWidget {
//   final String title;
//   final double price;
//   final String currencyCode;
//   final bool isSelected;
//   final ValueChanged<bool?> onChanged;

//   const ModernCheckboxTile({
//     super.key,
//     required this.title,
//     required this.price,
//     required this.currencyCode,
//     required this.isSelected,
//     required this.onChanged,
//   });

//   @override
//   State<ModernCheckboxTile> createState() => ModernCheckboxTileState();
// }

// class ModernCheckboxTileState extends State<ModernCheckboxTile> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () => widget.onChanged(!widget.isSelected),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: widget.isSelected
//                 ? Colors.pink.shade50
//                 : _isHovered
//                 ? Colors.grey.shade50
//                 : Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: widget.isSelected
//                   ? Colors.pink
//                   : _isHovered
//                   ? Colors.grey.shade300
//                   : Colors.grey.shade200,
//               width: widget.isSelected ? 2 : 1.5,
//             ),
//           ),
//           child: Row(
//             children: [
//               // Custom Checkbox
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: widget.isSelected ? Colors.pink : Colors.white,
//                   borderRadius: BorderRadius.circular(6),
//                   border: Border.all(color: widget.isSelected ? Colors.pink : Colors.grey.shade400, width: 2),
//                 ),
//                 child: widget.isSelected ? Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
//               ),
//               const SizedBox(width: 12),

//               // Title
//               Expanded(
//                 child: Text(
//                   widget.title,
//                   style: TextStyle(fontSize: 15, fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500, color: Color(0xFF2D3142)),
//                 ),
//               ),

//               // Price
//               if (widget.price > 0)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(color: widget.isSelected ? Colors.pink : Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
//                   child: Text(
//                     '+ ${widget.currencyCode}${widget.price.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: widget.isSelected ? Colors.white : Colors.grey.shade700),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // MODERN RADIO TILE WIDGET (unchanged)
// class ModernRadioTile extends StatefulWidget {
//   final String title;
//   final double price;
//   final String currencyCode;
//   final String value;
//   final String? groupValue;
//   final ValueChanged<String?> onChanged;

//   const ModernRadioTile({
//     super.key,
//     required this.title,
//     required this.price,
//     required this.currencyCode,
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//   });

//   @override
//   State<ModernRadioTile> createState() => ModernRadioTileState();
// }

// class ModernRadioTileState extends State<ModernRadioTile> {
//   bool _isHovered = false;

//   bool get isSelected => widget.value == widget.groupValue;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () => widget.onChanged(widget.value),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? Colors.pink.shade50
//                 : _isHovered
//                 ? Colors.grey.shade50
//                 : Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected
//                   ? Colors.pink
//                   : _isHovered
//                   ? Colors.grey.shade300
//                   : Colors.grey.shade200,
//               width: isSelected ? 2 : 1.5,
//             ),
//           ),
//           child: Row(
//             children: [
//               // Custom Radio Button
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: isSelected ? Colors.pink : Colors.grey.shade400, width: 2),
//                 ),
//                 child: isSelected
//                     ? Center(
//                         child: Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
//                         ),
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 12),

//               // Title
//               Expanded(
//                 child: Text(
//                   widget.title,
//                   style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: Color(0xFF2D3142)),
//                 ),
//               ),

//               // Price
//               if (widget.price > 0)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(color: isSelected ? Colors.pink : Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
//                   child: Text(
//                     '+ ${widget.currencyCode}${widget.price.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade700),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // QUANTITY BUTTON WIDGET (unchanged)
// class QuantityButton extends StatefulWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//   final bool isEnabled;

//   const QuantityButton({super.key, required this.icon, required this.onPressed, this.isEnabled = true});

//   @override
//   State<QuantityButton> createState() => QuantityButtonState();
// }

// class QuantityButtonState extends State<QuantityButton> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
//       child: GestureDetector(
//         onTap: widget.isEnabled ? widget.onPressed : null,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: widget.isEnabled ? (_isHovered ? Colors.pink : Colors.transparent) : Colors.grey.shade100,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(widget.icon, size: 20, color: widget.isEnabled ? (_isHovered ? Colors.white : Colors.grey.shade700) : Colors.grey.shade400),
//         ),
//       ),
//     );
//   }
// }
