// import 'package:flutter/material.dart';
// import 'package:pos_menu/Infrastructor/styleColor.dart';

// class ButtonWidget extends StatelessWidget {
//   final void Function() onPress;
//   final String text;
//   Color? colorButton;
//   Color? colorBoder;
//   Color? colorText;
//   ButtonWidget({super.key, required this.onPress, required this.text, this.colorButton, this.colorBoder, this.colorText}) {
//     colorButton ??= StyleColor.mainColor;
//     colorBoder ??= Colors.white;
//     colorText ??= Colors.white;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPress,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: colorButton,
//         foregroundColor: colorText,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: BorderSide(color: colorBoder!, width: 2),
//         ),
//       ),
//       child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//     );
//   }
// }
