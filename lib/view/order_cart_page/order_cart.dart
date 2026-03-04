// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:pos_menu/API/ApiExtension.dart';
// import 'package:pos_menu/API/domainame.dart';
// import 'package:pos_menu/Infrastructor/providerListener.dart';
// import 'package:pos_menu/Infrastructor/singleton.dart';
// import 'package:pos_menu/Infrastructor/styleColor.dart';
// import 'package:pos_menu/controller/sale_provider.dart';
// import 'package:pos_menu/model/sale/sale_invoice_model.dart';
// import 'package:pos_menu/model/store/exchange_rate_model.dart';
// import 'package:pos_menu/model/user/user_model.dart';
// import 'package:pos_menu/widget/animated_button.dart';
// import 'package:pos_menu/widget/button_widget.dart';
// import 'package:pos_menu/widget/cart_menu.dart';

// class OrderCart extends StatefulWidget {
//   String dbCode = "";
//   String table_code = "";
//   OrderCart({super.key, this.dbCode = "", this.table_code = ""});

//   @override
//   State<OrderCart> createState() => _OrderCartState();
// }

// class _OrderCartState extends State<OrderCart> with TickerProviderStateMixin {
//   late AnimationController _summaryController;
//   late AnimationController _headerController;
//   late Animation<double> _summaryAnimation;
//   late Animation<Offset> _headerSlideAnimation;

//   int numberOfGuests = 1;
//   bool showGuestSelector = false;

//   @override
//   void initState() {
//     super.initState();

//     _summaryController = AnimationController(duration: Duration(milliseconds: 600), vsync: this);
//     _headerController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
//     _summaryAnimation = CurvedAnimation(parent: _summaryController, curve: Curves.easeOutCubic);
//     _headerSlideAnimation = Tween<Offset>(
//       begin: Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));

//     _summaryController.forward();
//     _headerController.forward();
//   }

//   @override
//   void dispose() {
//     _summaryController.dispose();
//     _headerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isDesktop = screenWidth > 900;
//     final isTablet = screenWidth > 600 && screenWidth <= 900;
//     final isMobile = screenWidth <= 600;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () => context.pop(),
//           icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black87, size: isMobile ? 20 : 24),
//         ),
//         title: SlideTransition(
//           position: _headerSlideAnimation,
//           child: Text(
//             "Order Cart",
//             style: isMobile ? StyleColor.textHeaderStyleKhmerContent18Bold.copyWith(fontSize: 16) : StyleColor.textHeaderStyleKhmerContent18Bold,
//           ),
//         ),
//         actions: [
//           if (isDesktop)
//             SlideTransition(
//               position: _headerSlideAnimation,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 20),
//                 child: Center(
//                   child: Hero(
//                     tag: 'cart_badge',
//                     child: Consumer<ProviderListener>(
//                       builder: (context, listenProvider, child) {
//                         return Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [StyleColor.mainColor, StyleColor.mainColor.withOpacity(0.8)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [BoxShadow(color: StyleColor.mainColor.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))],
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.shopping_cart, size: 18, color: Colors.white),
//                               SizedBox(width: 8),
//                               Text(
//                                 '${listenProvider.saleCartItems.length} Items',
//                                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Consumer<ProviderListener>(
//         builder: (context, listenProvider, child) {
//           final menu = listenProvider.saleCartItems;

//           if (menu.isEmpty) {
//             return _buildEmptyCart(isMobile);
//           }

//           return Center(
//             child: Container(
//               constraints: BoxConstraints(maxWidth: isDesktop ? 1400 : double.infinity),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Cart Items Section
//                   Expanded(
//                     flex: isDesktop ? 7 : 1,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         left: isMobile ? 12 : (isDesktop ? 24 : 16),
//                         bottom: 0,
//                         right: 0,
//                         top: isMobile ? 8 : (isDesktop ? 24 : 0),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Mobile: Cart count and guest selector toggle
//                           if (isMobile) ...[
//                             Padding(
//                               padding: const EdgeInsets.only(right: 12, bottom: 12),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(Icons.shopping_bag_outlined, color: StyleColor.mainColor, size: 20),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         '${menu.length} ${menu.length == 1 ? 'Item' : 'Items'}',
//                                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
//                                       ),
//                                     ],
//                                   ),
//                                   _buildMobileGuestButton(),
//                                 ],
//                               ),
//                             ),
//                           ],

//                           // Table Header (Desktop only)
//                           if (isDesktop)
//                             FadeTransition(
//                               opacity: _summaryAnimation,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [Colors.white, Colors.grey[50]!],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 40,
//                                       child: Text(
//                                         'N.',
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                                       ),
//                                     ),
//                                     SizedBox(width: 15),
//                                     Expanded(
//                                       flex: 3,
//                                       child: Text(
//                                         'Item',
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         'Unit Price',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         'Quantity',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 100,
//                                       child: Text(
//                                         'Total',
//                                         textAlign: TextAlign.right,
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
//                                       ),
//                                     ),
//                                     SizedBox(width: 50),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                           SizedBox(height: isDesktop ? 16 : 0),

//                           // Cart Items List
//                           Expanded(
//                             child: Scrollbar(
//                               thumbVisibility: !isMobile,
//                               thickness: 8,
//                               radius: Radius.circular(10),
//                               child: ListView.separated(
//                                 padding: EdgeInsets.only(bottom: 15, right: isMobile ? 12 : 15, top: isMobile ? 0 : 15),
//                                 itemCount: menu.length,
//                                 separatorBuilder: (context, index) => SizedBox(height: isMobile ? 8 : 12),
//                                 itemBuilder: (context, index) {
//                                   final menuCart = menu[index];
//                                   return TweenAnimationBuilder<double>(
//                                     duration: Duration(milliseconds: 400 + (index * 50)),
//                                     tween: Tween(begin: 0.0, end: 1.0),
//                                     curve: Curves.easeOutCubic,
//                                     builder: (context, value, child) {
//                                       return Transform.translate(
//                                         offset: Offset(50 * (1 - value), 0),
//                                         child: Opacity(opacity: value, child: child),
//                                       );
//                                     },
//                                     child: CartMenu(
//                                       key: ValueKey('${menuCart.menu.itemCode}_$index'),
//                                       index: index,
//                                       name: menuCart.menu.itemDesc ?? '',
//                                       unitPrice: menuCart.menu.itemStorePrice?.toDouble() ?? 0.0,
//                                       price: menuCart.menu.itemPrice?.toDouble() ?? 0.0,
//                                       addon: listenProvider.saleCartItems[index].selectedChoices.map((c) => c.choiceName ?? '').join(', '),
//                                       image: '${Domain.baseUrl}/${menuCart.menu.itemImg.toString()}',
//                                       qty: menuCart.orderCount.toInt() ?? 0,
//                                       menu: menuCart.menu,
//                                       isDesktop: isDesktop,
//                                       isTablet: isTablet,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Summary Section (Desktop only)
//                   if (isDesktop)
//                     ScaleTransition(
//                       scale: _summaryAnimation,
//                       child: Container(width: 380, padding: EdgeInsets.all(20), child: _buildOrderSummary(isDesktop: true)),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       // Bottom Summary for Mobile/Tablet
//       bottomNavigationBar: !isDesktop ? _buildMobileBottomBar(isMobile) : null,
//     );
//   }

//   Widget _buildEmptyCart(bool isMobile) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.shopping_cart_outlined, size: isMobile ? 80 : 120, color: Colors.grey[300]),
//           SizedBox(height: 24),
//           Text(
//             'Your cart is empty',
//             style: TextStyle(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 12),
//           Text(
//             'Add some items to get started',
//             style: TextStyle(fontSize: isMobile ? 14 : 16, color: Colors.grey[500]),
//           ),
//           SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: () => context.pop(),
//             icon: Icon(Icons.restaurant_menu),
//             label: Text('Browse Menu'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: StyleColor.mainColor,
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileGuestButton() {
//     return GestureDetector(
//       onTap: () {
//         setState(() => showGuestSelector = !showGuestSelector);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: StyleColor.mainColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: StyleColor.mainColor.withOpacity(0.3)),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.people_outline, size: 16, color: StyleColor.mainColor),
//             SizedBox(width: 6),
//             Text(
//               '$numberOfGuests ${numberOfGuests == 1 ? 'Guest' : 'Guests'}',
//               style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: StyleColor.mainColor),
//             ),
//             SizedBox(width: 4),
//             Icon(showGuestSelector ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: StyleColor.mainColor),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGuestSelector({required bool isMobile, required bool isCompact}) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       padding: EdgeInsets.all(isCompact ? 10 : 15),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.white, Colors.grey[50]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.people, color: StyleColor.mainColor, size: isCompact ? 15 : 18),
//               SizedBox(width: 6),
//               Text(
//                 'Number of Guests',
//                 style: TextStyle(fontSize: isCompact ? 14 : 15, fontWeight: FontWeight.w600, color: Colors.black87),
//               ),
//             ],
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildGuestButton(
//                   icon: Icons.remove,
//                   onPressed: numberOfGuests > 1 ? () => setState(() => numberOfGuests--) : null,
//                   isCompact: isCompact,
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: isCompact ? 10 : 13, vertical: isCompact ? 3 : 5),
//                   child: Text(
//                     '$numberOfGuests',
//                     style: TextStyle(fontSize: isCompact ? 13 : 15, fontWeight: FontWeight.bold, color: StyleColor.mainColor),
//                   ),
//                 ),
//                 _buildGuestButton(
//                   icon: Icons.add,
//                   onPressed: numberOfGuests < 20 ? () => setState(() => numberOfGuests++) : null,
//                   isCompact: isCompact,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGuestButton({required IconData icon, required VoidCallback? onPressed, required bool isCompact}) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           padding: EdgeInsets.all(isCompact ? 6 : 8),
//           child: Icon(icon, size: isCompact ? 18 : 20, color: onPressed != null ? StyleColor.mainColor : Colors.grey[300]),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary({required bool isDesktop}) {
//     return Consumer2<ProviderListener, ApiExtension>(
//       builder: (context, listenProvider, apiExtension, child) {
//         final shopData = apiExtension.shopData;
//         final exchangeRate = double.tryParse(shopData?.exchangeRate?.first.siData.toString() ?? '1') ?? 1.0;

//         return Container(
//           padding: EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, 4))],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: [StyleColor.mainColor.withOpacity(0.2), StyleColor.mainColor.withOpacity(0.1)]),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(Icons.receipt_long, color: StyleColor.mainColor, size: 22),
//                   ),
//                   SizedBox(width: 12),
//                   Text(
//                     'Order Summary',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24),

//               // Guest Selector
//               _buildGuestSelector(isMobile: false, isCompact: false),
//               SizedBox(height: 20),

//               // Price breakdown
//               _buildSummaryRow('Subtotal', double.parse('${listenProvider.saleTotalPrice}')),
//               SizedBox(height: 12),
//               _buildSummaryRow('Discount', 0, color: Colors.green[600]),
//               SizedBox(height: 12),
//               _buildSummaryRow('Tax (0%)', double.tryParse(shopData?.vat?.map((e) => e.siData.toString()).toString() ?? '') ?? 0.0),
//               SizedBox(height: 16),
//               Divider(thickness: 1.5, color: Colors.grey[300]),
//               SizedBox(height: 16),

//               // Total
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [StyleColor.mainColor.withOpacity(0.1), StyleColor.mainColor.withOpacity(0.05)]),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     _buildSummaryRow('Total', double.parse('${listenProvider.saleTotalPrice}'), isBold: true, fontSize: 22),
//                     if (exchangeRate != 1.0) ...[
//                       SizedBox(height: 4),
//                       _buildSummaryRow(
//                         '≈ KHR',
//                         double.parse('${listenProvider.saleTotalPrice * exchangeRate}'),
//                         isBold: true,
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               SizedBox(height: 24),

//               // Place Order Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: AnimatedButton(onPress: () => _handlePlaceOrder(context, exchangeRate), text: "Place Order", colorBoder: StyleColor.mainColor),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSummaryRow(String label, double value, {bool isBold = false, double fontSize = 15, Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color ?? Colors.grey[700]),
//           ),
//           Text(
//             '\$${value.toStringAsFixed(2)}',
//             style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color ?? Colors.black87),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileBottomBar(bool isMobile) {
//     return Consumer2<ProviderListener, ApiExtension>(
//       builder: (context, listenProvider, apiExtension, child) {
//         final exchangeRate = double.tryParse(apiExtension.shopData?.exchangeRate?.first.siData.toString() ?? '1') ?? 1.0;

//         return Container(
//           padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, -4))],
//           ),
//           child: SafeArea(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Guest selector expandable
//                 if (showGuestSelector) ...[_buildGuestSelector(isMobile: true, isCompact: true), SizedBox(height: 12)],

//                 // Total row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total',
//                           style: TextStyle(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w500, color: Colors.grey[600]),
//                         ),
//                         SizedBox(height: 2),
//                         TweenAnimationBuilder<double>(
//                           duration: Duration(milliseconds: 800),
//                           tween: Tween(begin: 0.0, end: double.parse('${listenProvider.saleTotalPrice}')),
//                           curve: Curves.easeOutCubic,
//                           builder: (context, value, child) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '\$${value.toStringAsFixed(2)}',
//                                   style: TextStyle(fontSize: isMobile ? 24 : 26, fontWeight: FontWeight.bold, color: StyleColor.mainColor),
//                                 ),
//                                 if (exchangeRate != 1.0)
//                                   Text(
//                                     '= ៛${(value * exchangeRate).toStringAsFixed(0)}',
//                                     style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
//                                   ),
//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       width: isMobile ? 160 : 160,
//                       height: isMobile ? 48 : 52,
//                       child: AnimatedButton(
//                         onPress: () => _handlePlaceOrder(context, exchangeRate),
//                         text: "Place Order",
//                         colorBoder: StyleColor.mainColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _handlePlaceOrder(BuildContext context, double exchange) async {
//     try {
//       UserModel? adminUser = Singleton.instance.allUsers?.users?.firstWhere((element) => element.userType == "A", orElse: () => UserModel());

//       final stor = Provider.of<ApiExtension>(context, listen: false).shopData;
//       final saleProvider = Provider.of<SaleProvider>(context, listen: false);
//       var adminId = adminUser?.userCode;

//       if (saleProvider.selectedTransRef != null) {
//         final result = await saleProvider.updateSaleOrder(
//           context: context,
//           body: {
//             "ADD_CODE": saleProvider.customerCode,
//             "MENUS": Provider.of<ProviderListener>(context, listen: false).saleCartItems.map((e) => e.toJson()).toList(),
//             "TOTAL": Provider.of<ProviderListener>(context, listen: false).saleTotalPrice,
//             "DISCOUNT": "0.00",
//             "EXCHANGE_RATE": exchange ?? 4000,
//             "VAT": "0.00",
//             "COMMENT": "",
//             "DB_CODE": widget.dbCode,
//             "TABLE_CODE": widget.table_code,
//             "TABLE_NAME": saleProvider.selectTableName,
//             "NUM_GUEST": saleProvider.numberGuest,
//             "DININGTYPE": 'U',
//             "TRANS_REF": saleProvider.selectedTransRef,
//           },
//         );
//         if (result == true) {
//           // Clear the sale provider data for next order
//           saleProvider.selectedTransRef = null;
//           saleProvider.orderDateTime = null;
//           saleProvider.listSaleCart.clear();
//           saleProvider.stockOldOnOrder.clear();

//           // Navigate to home page
//           if (mounted) {
//             context.pushReplacement('/${widget.dbCode}${widget.table_code.isNotEmpty ? '?table=${widget.table_code}' : ''}');
//           }
//         }
//       } else {
//         SaleInvoiceModel? result = await Provider.of<SaleProvider>(context, listen: false).postOrder(
//           context: context,
//           body: {
//             "MENUS": Provider.of<ProviderListener>(context, listen: false).saleCartItems.map((e) => e.toJson()).toList(),
//             "TOTAL": Provider.of<ProviderListener>(context, listen: false).saleTotalPrice,
//             "ADMIN_ID": adminId,
//             "DISCOUNT": "0.00",
//             "EXCHANGE_RATE": stor?.exchangeRate?.first.siData ?? "1.00",
//             "VAT": "0.00",
//             "COMMENT": "",
//             "DB_CODE": widget.dbCode,
//             "TABLE_CODE": widget.table_code,
//             "NUM_GUEST": numberOfGuests,
//             "DININGTYPE": 'U',
//           },
//         );

//         if (result != null) {
//           // Clear the sale provider data for next order
//           saleProvider.selectedTransRef = null;
//           saleProvider.orderDateTime = null;
//           saleProvider.listSaleCart.clear();
//           saleProvider.stockOldOnOrder.clear();

//           // Navigate to home page
//           if (mounted) {
//             context.pushReplacement('/${widget.dbCode}${widget.table_code.isNotEmpty ? '?table=${widget.table_code}' : ''}');
//           }
//         }
//       }
//     } catch (e) {
//       log("Error placing order: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order. Please try again.'), backgroundColor: Colors.red));
//     }
//   }
// }
