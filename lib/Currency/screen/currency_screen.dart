// import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_menu/Currency/provider/currency_provider.dart';
// import 'package:pos_menu/Infrastructor/styleColor.dart';
// import 'package:provider/provider.dart';

// class CurrencyScreen extends StatefulWidget {
//   const CurrencyScreen({super.key});

//   @override
//   State<CurrencyScreen> createState() => _CurrencyScreenState();
// }

// class _CurrencyScreenState extends State<CurrencyScreen> {
//   String fillterStatus = 'A';
//   @override
//   void initState() {
//     Provider.of<CurrencyProvider>(context, listen: false).getAllCurrency(context: context, status: 'A');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CurrencyProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           backgroundColor: StyleColor.appBackgroundColor,
//           appBar: Platform.isWindows
//               ? null
//               : AppBar(
//                   title: Text("btn.បង្កើត".tr(), style: StyleColor.textStyleKhmerDangrek18White),
//                   actions: [
//                     CreateButtonWidget(
//                       onCreate: () async {
//                         await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCurrencyScreen()));
//                       },
//                     ),
//                   ],
//                   leading: const BackButtonWidget(),
//                 ),
//           body: Column(
//             children: [
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, right: 19),
//                 child: Row(
//                   children: [
//                     SearchTextFieldWidget(hintText: 'label.ស្វែងរក ​រូបិយវត្ថុ'.tr()),
//                     const SizedBox(width: 10),
//                     ActiveDropDownWidget(
//                       currentValue: fillterStatus,
//                       onChanged: (values) async {
//                         fillterStatus = values.toString();
//                         await provider.getAllCurrency(context: context, status: values);
//                         setState(() {});
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Flexible(
//                 child: provider.allCurrenctList.isEmpty
//                     ? NoData()
//                     : ListView.builder(
//                         itemCount: provider.allCurrenctList.length,
//                         padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) {
//                           return RenderCurrencyWidget(
//                             data: provider.allCurrenctList[index],
//                             onTapCard: () async {
//                               await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => ChangeNotifierProvider.value(
//                                     value: provider,
//                                     child: AddEditCurrencyScreen(isEdit: true, data: provider.allCurrenctList[index]),
//                                   ),
//                                 ),
//                               );
//                             },
//                             trailing: fillterStatus == 'A'
//                                 ? InkWell(
//                                     onTap: () async {
//                                       await provider.disable(context: context, id: provider.allCurrenctList[index].id.toString(), status: 'D');
//                                       await provider.getAllCurrency(context: context, status: 'A');
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(6),
//                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.red.shade100),
//                                       child: const Icon(Icons.delete, color: Colors.red),
//                                     ),
//                                   )
//                                 : InkWell(
//                                     onTap: () async {
//                                       await provider.disable(context: context, id: provider.allCurrenctList[index].id.toString(), status: 'A');
//                                       await provider.getAllCurrency(context: context, status: 'D');
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(6),
//                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black12),
//                                       child: const Icon(Icons.history, color: Colors.black87),
//                                     ),
//                                   ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
