// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pos_menu/Infrastructor/modernPopupDialog.dart';
// import 'package:pos_menu/Infrastructor/providerListener.dart';
// import 'package:pos_menu/Infrastructor/styleColor.dart';
// import 'package:pos_menu/model/menu/menu_model.dart';
// import 'package:pos_menu/widget/network_ImageView.dart';

// class CartMenu extends StatefulWidget {
//   final int index;
//   final String name;
//   final MenuModel? menu;
//   final double unitPrice;
//   final int qty;
//   final double price;
//   final String addon;
//   final String image;
//   final bool isDesktop;
//   final bool isTablet;

//   const CartMenu({
//     super.key,
//     required this.index,
//     required this.name,
//     required this.unitPrice,
//     required this.price,
//     required this.addon,
//     required this.image,
//     required this.qty,
//     this.menu,
//     this.isDesktop = false,
//     this.isTablet = false,
//   });

//   @override
//   State<CartMenu> createState() => _CartMenuState();
// }

// class _CartMenuState extends State<CartMenu> with SingleTickerProviderStateMixin {
//   bool _isHovered = false;
//   late AnimationController _deleteController;
//   late Animation<double> _deleteAnimation;
//   int _currentQty = 0;
//   bool _isDeleting = false;

//   @override
//   void didUpdateWidget(CartMenu oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.qty != widget.qty) {
//       setState(() {
//         _currentQty = widget.qty;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _currentQty = widget.qty;
//     _deleteController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
//     _deleteAnimation = CurvedAnimation(parent: _deleteController, curve: Curves.easeInOut);
//   }

//   @override
//   void dispose() {
//     _deleteController.dispose();
//     super.dispose();
//   }

//   void _onQuantityChanged(int delta) {
//     if (_isDeleting) return;

//     final providerListener = context.read<ProviderListener>();

//     if (widget.index >= providerListener.saleCartItems.length) return;

//     final currentQty = providerListener.saleCartItems[widget.index].orderCount.toInt();
//     final newQty = currentQty + delta;

//     if (newQty <= 0) {
//       _showDeleteConfirmation();
//     } else {
//       if (widget.menu != null) {
//         providerListener.addToSaleCart(widget.menu!, delta, addcart: true, queue: widget.menu?.queue ?? -1);

//         setState(() {
//           _currentQty = newQty;
//         });
//       }
//     }
//   }

//   void _showDeleteConfirmation() {
//     if (_isDeleting) return;

//     ModernPopupDialog.yesNoPrompt(
//       context,
//       content: 'msg.តើអ្នកចង់លុបវាចេញពីបញ្ជីបញ្ជាទិញទេ?',
//       onCancel: () {
//         Navigator.pop(context);
//       },
//       onOk: () {
//         Navigator.pop(context);
//         _performDelete();
//       },
//     );
//   }

//   void _performDelete() {
//     if (_isDeleting) return;

//     setState(() {
//       _isDeleting = true;
//     });

//     final providerListener = context.read<ProviderListener>();

//     _deleteController.forward().then((_) {
//       if (widget.index < providerListener.saleCartItems.length) {
//         final currentItem = providerListener.saleCartItems[widget.index];

//         if (widget.menu != null && currentItem.menu.itemCode == widget.menu!.itemCode) {
//           providerListener.removeCartItemByIndex(widget.index);
//           providerListener.debugCartState("After delete - ${widget.menu!.itemCode}");
//         }
//       }
//     });
//   }

//   void onDelete() {
//     _showDeleteConfirmation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_deleteAnimation),
//       child: SlideTransition(
//         position: Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(_deleteAnimation),
//         child: widget.isDesktop ? buildDesktopCard() : buildMobileCard(),
//       ),
//     );
//   }

//   Widget buildDesktopCard() {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         transform: Matrix4.identity()..scale(_isHovered ? 1.005 : 1.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _isHovered ? StyleColor.mainColor.withOpacity(0.3) : Colors.transparent, width: 2),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.05),
//               blurRadius: _isHovered ? 15 : 10,
//               offset: Offset(0, _isHovered ? 4 : 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Index Number - Fixed width
//             SizedBox(
//               width: 40,
//               child: TweenAnimationBuilder<double>(
//                 duration: Duration(milliseconds: 300),
//                 tween: Tween(begin: 0.0, end: 1.0),
//                 builder: (context, value, child) {
//                   return Transform.scale(
//                     scale: value,
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(color: StyleColor.mainColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//                       alignment: Alignment.center,
//                       child: Text(
//                         '${widget.index + 1}',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: StyleColor.mainColor),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(width: 15),

//             // Image - Fixed width
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey[100],
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
//                 image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.cover),
//               ),
//             ),
//             SizedBox(width: 16),

//             // Name and Addon - Flexible with constraints
//             Expanded(
//               flex: 3,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     widget.name,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   if (widget.addon.isNotEmpty) ...[
//                     SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.restaurant_menu, size: 12, color: Colors.grey[500]),
//                         SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             widget.addon,
//                             style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             SizedBox(width: 12),

//             // Unit Price - Fixed width
//             SizedBox(
//               width: 90,
//               child: Text(
//                 '\$${widget.unitPrice.toStringAsFixed(2)}',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
//               ),
//             ),

//             // Quantity Controls - Fixed width
//             SizedBox(
//               width: 130,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildQuantityButton(Icons.remove, () => _onQuantityChanged(-1)),
//                   AnimatedSwitcher(
//                     duration: Duration(milliseconds: 200),
//                     transitionBuilder: (child, animation) {
//                       return ScaleTransition(scale: animation, child: child);
//                     },
//                     child: Container(
//                       key: ValueKey<int>(_currentQty),
//                       width: 40,
//                       alignment: Alignment.center,
//                       child: Text(
//                         '$_currentQty',
//                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   buildQuantityButton(Icons.add, () => _onQuantityChanged(1)),
//                 ],
//               ),
//             ),

//             // Total Price - Fixed width
//             TweenAnimationBuilder<double>(
//               duration: Duration(milliseconds: 300),
//               tween: Tween(begin: widget.price, end: widget.unitPrice * _currentQty),
//               builder: (context, value, child) {
//                 return Text(
//                   '\$${value.toStringAsFixed(2)}',
//                   textAlign: TextAlign.right,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: StyleColor.mainColor),
//                 );
//               },
//             ),

//             // Delete Button - Fixed width
//             SizedBox(
//               width: 50,
//               child: Center(
//                 child: IconButton(
//                   onPressed: _isDeleting ? null : onDelete,
//                   icon: Icon(Icons.delete_outline),
//                   color: Colors.red[400],
//                   tooltip: 'Remove item',
//                   hoverColor: Colors.red[50],
//                   iconSize: 22,
//                   padding: EdgeInsets.all(8),
//                   constraints: BoxConstraints(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildMobileCard() {
//     final isMobile = MediaQuery.of(context).size.width <= 600;

//     return AnimatedContainer(
//       duration: Duration(milliseconds: 200),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image
//           Container(
//             width: isMobile ? 75 : 80,
//             height: isMobile ? 75 : 80,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey[100],
//               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
//               image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.cover),
//             ),
//           ),
//           SizedBox(width: 12),

//           // Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name and Delete button
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         widget.name,
//                         style: TextStyle(fontSize: isMobile ? 14 : 15, fontWeight: FontWeight.w600, color: Colors.black87),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         onTap: _isDeleting ? null : onDelete,
//                         borderRadius: BorderRadius.circular(20),
//                         child: Padding(
//                           padding: EdgeInsets.all(4),
//                           child: Icon(Icons.delete_outline, color: Colors.red[400], size: 20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Addon
//                 if (widget.addon.isNotEmpty) ...[
//                   SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.restaurant_menu, size: 12, color: Colors.grey[500]),
//                       SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           widget.addon,
//                           style: TextStyle(fontSize: isMobile ? 11 : 12, color: Colors.grey[600]),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],

//                 SizedBox(height: 10),

//                 // Price, Quantity, and Total
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Unit Price
//                     Text(
//                       '\$${widget.unitPrice.toStringAsFixed(2)}',
//                       style: TextStyle(fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
//                     ),

//                     // Quantity Controls
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[50],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey[200]!),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           buildQuantityButton(Icons.remove, () => _onQuantityChanged(-1), small: true),
//                           AnimatedSwitcher(
//                             duration: Duration(milliseconds: 200),
//                             transitionBuilder: (child, animation) {
//                               return ScaleTransition(scale: animation, child: child);
//                             },
//                             child: Container(
//                               key: ValueKey<int>(_currentQty),
//                               width: 32,
//                               alignment: Alignment.center,
//                               child: Text(
//                                 '$_currentQty',
//                                 style: TextStyle(fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ),
//                           buildQuantityButton(Icons.add, () => _onQuantityChanged(1), small: true),
//                         ],
//                       ),
//                     ),

//                     // Total Price
//                     TweenAnimationBuilder<double>(
//                       duration: Duration(milliseconds: 300),
//                       tween: Tween(begin: widget.price, end: widget.unitPrice * _currentQty),
//                       builder: (context, value, child) {
//                         return Text(
//                           '\$${value.toStringAsFixed(2)}',
//                           style: TextStyle(fontSize: isMobile ? 15 : 16, fontWeight: FontWeight.bold, color: StyleColor.mainColor),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildQuantityButton(IconData icon, VoidCallback onPressed, {bool small = false}) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 150),
//       tween: Tween(begin: 0.0, end: 1.0),
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: _isDeleting ? null : onPressed,
//               borderRadius: BorderRadius.circular(6),
//               child: Container(
//                 width: small ? 28 : 32,
//                 height: small ? 28 : 32,
//                 decoration: BoxDecoration(
//                   color: small ? Colors.transparent : Colors.white,
//                   borderRadius: BorderRadius.circular(6),
//                   border: small ? null : Border.all(color: StyleColor.mainColor),
//                   boxShadow: small ? null : [BoxShadow(color: StyleColor.mainColor.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))],
//                 ),
//                 child: Icon(icon, size: small ? 14 : 16, color: StyleColor.mainColor),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
