// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_menu/Currency/model/currency_mode.dart';
// import 'package:pos_menu/Currency/provider/currency_provider.dart';
// import 'package:pos_menu/Extension/dynamic_icon_currency.dart';
// import 'package:pos_menu/Infrastructor/styleColor.dart';
// import 'package:provider/provider.dart';

// class AddEditCurrencyScreen extends StatefulWidget {
//   const AddEditCurrencyScreen({super.key, this.isEdit = false, this.data});
//   final bool isEdit;
//   final CurrencyModel? data;

//   @override
//   State<AddEditCurrencyScreen> createState() => _AddEditCurrencyScreenState();
// }

// class _AddEditCurrencyScreenState extends State<AddEditCurrencyScreen> {
//   File? supplierImage;
//   final TextEditingController _nameContrller = TextEditingController();
//   final TextEditingController _rateContrller = TextEditingController();
//   final TextEditingController _typeContrller = TextEditingController();
//   final TextEditingController _noteContrller = TextEditingController();
//   bool setPrimary = false;
//   // String? currencyCode;
//   String? selectedCurrencyCode;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.isEdit) {
//         _nameContrller.text = widget.data?.dataName ?? "";
//         _rateContrller.text = widget.data?.rate ?? "";
//         _typeContrller.text = widget.data?.dataCode ?? "";
//         _noteContrller.text = widget.data?.note ?? "";
//         setState(() {});
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _noteContrller.dispose();
//     _typeContrller.dispose();
//     _rateContrller.dispose();
//     _nameContrller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CurrencyProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           backgroundColor: StyleColor.appBackgroundColor,
//           // appBar: AppBar(
//           //   title: Text("label.ការកំណត់ រូបិយវត្ថុ".tr(), style: StyleColor.textStyleKhmerDangrek18White),
//           //   leading: BackButtonWidget(onBack: () {}),
//           // ),
//           body: SizedBox(
//             height: double.infinity,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 20),
//                     height: 100,
//                     width: 100,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       // border: Border.all(color: Colors.grey, width: 1),
//                       // boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)],
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: (selectedCurrencyCode?.isNotEmpty == true || widget.data?.dataCode?.isNotEmpty == true)
//                         ? Text(
//                             CurrencyExtention.currencyIconSecond(currencyCode: selectedCurrencyCode ?? widget.data?.dataCode),
//                             style: StyleColor.textStyleKhmerContentBlack.copyWith(fontWeight: FontWeight.w600, fontSize: 50),
//                           )
//                         : FittedBox(fit: BoxFit.scaleDown, child: NoData()),
//                   ),
//                   // PickPhoto(
//                   //   value: (image) {
//                   //     supplierImage = image;
//                   //   },
//                   //   isEdit: widget.isEdit,
//                   //   oldImage: widget.data?.image,
//                   // ),
//                   // const SizedBox(height: 40),
//                   InputTextFiledWidget(labelText: "ឈ្មោះ", hintText: "ឈ្មោះ", prefixIcon: const Icon(Icons.person), controller: _nameContrller),
//                   const SizedBox(height: 10),
//                   InputTextFiledWidget(
//                     labelText: "អត្រា",
//                     hintText: "អត្រា",
//                     controller: _rateContrller,
//                     inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
//                     prefixIcon: const Icon(Icons.repeat_one_rounded),
//                   ),
//                   const SizedBox(height: 10),
//                   InputTextFiledWidget(
//                     hintText: "ប្រភេទ​ រូបិយវត្ថុ",
//                     labelText: "ប្រភេទ​ រូបិយវត្ថុ",
//                     controller: _typeContrller,
//                     readOnly: true,
//                     prefixIcon: const Icon(Icons.currency_exchange, size: 20),
//                     onTap: () {
//                       showCurrencyPicker(
//                         context: context,
//                         showFlag: true,
//                         showSearchField: true,
//                         showCurrencyName: true,
//                         showCurrencyCode: true,
//                         onSelect: (Currency currency) {
//                           _typeContrller.text = currency.code;
//                           selectedCurrencyCode = currency.code;
//                           setState(() {});
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   InputTextFiledWidget(
//                     hintText: "ចំណាំ",
//                     labelText: "ចំណាំ",
//                     controller: _noteContrller,
//                     prefixIcon: const Icon(Icons.note_alt_outlined),
//                   ),
//                   // const SizedBox(height: 15),
//                   // Row(
//                   //   children: [
//                   //     const SizedBox(width: 3),
//                   //     Text(
//                   //       "Set Primary".tr(),
//                   //       style: StyleColor.textStyleKhmerContent16.copyWith(color: Colors.black, fontSize: 14),
//                   //     ),
//                   //     const SizedBox(width: 10),
//                   //     InkWell(
//                   //       onTap: () {
//                   //         setState(() {
//                   //           if(widget.isEdit){
//                   //             widget.data?.primary = !(widget.data?.primary ?? false);
//                   //           }else{
//                   //             setPrimary = !setPrimary;
//                   //           }
//                   //         });
//                   //       },
//                   //       child: Container(
//                   //         height: 22.0,
//                   //         width: 22.0,
//                   //         decoration: BoxDecoration(
//                   //           color: (widget.isEdit ? (widget.data?.primary ?? false) : setPrimary)
//                   //           ? StyleColor.mainColor : Colors.transparent,
//                   //           border: Border.all(
//                   //             color: StyleColor.mainColor,
//                   //             width: 2.0,
//                   //           ),
//                   //           borderRadius: BorderRadius.circular(6.0),
//                   //         ),
//                   //         child: (widget.isEdit ? (widget.data?.primary ?? false) : setPrimary)
//                   //             ? const Icon(
//                   //                 Icons.check,
//                   //                 size: 15.0,
//                   //                 color: Colors.white,
//                   //               )
//                   //             : null,
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 15),
//                   InkWell(
//                     onTap: () {
//                       if (_nameContrller.text.trim().isEmpty) {
//                         PopupDialog.showPopup(context, "សូមបញ្ជួល ​ឈ្មោះ".tr(), layerContext: 1);
//                         return;
//                       } else if (_rateContrller.text.trim().isEmpty) {
//                         PopupDialog.showPopup(context, "សូមបញ្ជូល ​អត្រា".tr(), layerContext: 1);
//                         return;
//                       } else if (_typeContrller.text.trim().isEmpty) {
//                         PopupDialog.showPopup(context, "សូមបញ្ជូល រូបិយវត្ថុ".tr(), layerContext: 1);
//                         return;
//                       }

//                       var body = {
//                         "NAME": _nameContrller.text.trim(),
//                         "RATE": _rateContrller.text.trim(),
//                         "TYPE": _typeContrller.text.trim(),
//                         "NOTE": _noteContrller.text.trim(),
//                         "PRIMARY": widget.isEdit ? (widget.data?.primary ?? false) : setPrimary,
//                       };
//                       if (widget.isEdit) {
//                         provider.updateCurrency(context: context, data: body, image: supplierImage);
//                       } else {
//                         provider.postCurrency(context: context, data: body, image: supplierImage);
//                       }
//                     },
//                     child: SubmitButtonWidget(title: widget.isEdit ? 'Update'.tr() : 'Save'.tr()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
