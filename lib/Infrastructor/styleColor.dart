import 'package:flutter/material.dart';

class StyleColor {
  static Color mainColor = const Color.fromRGBO(140, 10, 57, 1);
  static Color mainColorLight = const Color.fromRGBO(191, 13, 78, 1);
  static Color mainColorLight2 = const Color.fromRGBO(253, 236, 242, 1);
  static Color mainColorLight3 = const Color.fromRGBO(157, 72, 115, 1);
  static Color mainColorLight4 = const Color.fromRGBO(233, 206, 219, 1);
  static Color mainColorLight5 = const Color(0xFFC94C6D);
  static Color iconColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color errorColor = Colors.red;
  static Color appBarColor = const Color.fromRGBO(140, 10, 57, 1);
  static const Color appBackgroundColor = Color(0xFFF3F5F6);
  static Color appBarColorLight = const Color.fromARGB(255, 242, 221, 227);
  static Color appColorRed = const Color.fromARGB(255, 222, 33, 19);
  static Color lightPink = const Color.fromRGBO(236, 235, 248, 1);
  static Color appBarGoldColor = const Color.fromRGBO(201, 160, 55, 1);
  static Color appBarDarkColor = const Color.fromRGBO(41, 93, 160, 1);
  static Color lightBlueColor = const Color.fromRGBO(213, 240, 254, 1);
  static Color radioBorderColor = const Color(0xFF2E1963);
  static TextStyle textHeaderStyleKhmerContent = const TextStyle(fontFamily: 'NotoSans', fontSize: 18);
  static TextStyle textHeaderStyleKhmerContentGrey = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, color: Colors.grey);
  static TextStyle textHeaderStyleKhmerKhAngBRodtha = const TextStyle(fontFamily: 'Kh Ang B.Rodtha', fontSize: 20);
  static TextStyle textHeaderStyleKhmerKhAngBRodthaWhite = const TextStyle(fontFamily: 'Kh Ang B.Rodtha', fontSize: 20, color: Colors.white);
  static TextStyle textHeaderStyleKhmerContent18Bold = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, fontWeight: FontWeight.bold);
  static const Color pink = Color(0xFFE8316A);

  static Color scaffold(bool dark) => dark ? const Color(0xFF0F1117) : const Color(0xFFF8F8FA);
  static Color card(bool dark) => dark ? const Color(0xFF1C1F2E) : Colors.white;
  static Color surface(bool dark) => dark ? const Color(0xFF252837) : const Color(0xFFF2F2F7);
  static Color header(bool dark) => dark ? const Color(0xFF1C1F2E) : Colors.white;
  static Color divider(bool dark) => dark ? const Color(0xFF2E3147) : const Color(0xFFF0F0F2);
  static Color border(bool dark) => dark ? const Color(0xFF2E3147) : Colors.grey.shade200;
  static Color chipBg(bool dark) => dark ? const Color(0xFF252837) : Colors.white;
  static Color chipBorder(bool dark) => dark ? const Color(0xFF3A3D52) : Colors.grey.shade300;

  static Color textPrimary(bool dark) => dark ? const Color(0xFFF0F0F5) : const Color(0xFF1A1D2E);
  static Color textSecondary(bool dark) => dark ? const Color(0xFF9094A8) : Colors.grey.shade500;
  static Color textHint(bool dark) => dark ? const Color(0xFF6B6F82) : Colors.grey.shade400;
  static TextStyle textHeaderStyleKhmerContent18BoldAppBarColor = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: StyleColor.appBarColor,
  );
  static TextStyle textHeaderStyleKhmerContent18BoldWhite = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static TextStyle textHeaderStyleKhmerContent16Bold = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle textHeaderStyleKhmerContentBoldAppBarColor = TextStyle(
    color: appBarColor,
    fontFamily: 'NotoSans',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textHeaderStyleKhmerContentBoldRed = const TextStyle(
    color: Colors.red,
    fontFamily: 'NotoSans',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textHeaderStyleKhmerContentWhite = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, color: Colors.white);
  static TextStyle textHeaderStyleKhmerContentWhite16 = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.white);
  static TextStyle textHeaderStyleKhmerContentWhite18 = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, color: Colors.white);
  static TextStyle textHeaderStyleKhmerContent12Grey = const TextStyle(fontFamily: 'NotoSans', fontSize: 12, color: Colors.grey);
  static TextStyle textHeaderStyleKhmerContent16 = const TextStyle(fontFamily: 'NotoSans', fontSize: 16);
  static TextStyle textHeaderStyleKhmerContent16LightColor3 = TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: mainColorLight3);
  static TextStyle textHeaderStyleKhmerContent16Grey = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.grey);
  static TextStyle textHeaderStyleKhmerContentBold16AppBarColor = TextStyle(
    color: appBarColor,
    fontFamily: 'NotoSans',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textHeaderStyleKhmerContent14 = const TextStyle(fontFamily: 'NotoSans', fontSize: 14);
  static TextStyle textHeaderStyleKhmerContentWhite14 = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white);
  static TextStyle textStyleHelveticaWhite14 = const TextStyle(fontFamily: 'Helvetica', fontSize: 14, color: Colors.white);

  static TextStyle textHeaderStyleHelveticaBold = const TextStyle(
    color: Colors.white,
    fontFamily: 'Helvetica',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textHeaderStyleHelvetica = const TextStyle(fontFamily: 'Helvetica', fontSize: 18);
  static TextStyle textHeaderStyleKhmerMoulLightAppBarColor = TextStyle(fontFamily: 'Khmer OS Moul Light', fontSize: 18, color: appBarColor);
  static TextStyle textHeaderStyleKhmerMoulLightGoldColor = const TextStyle(
    fontFamily: 'Khmer OS Moul Light',
    fontSize: 18,
    color: Color.fromRGBO(163, 141, 51, 1),
  );
  static TextStyle textHeaderStyleKhmerMoulLight = const TextStyle(fontFamily: 'Khmer OS Moul Light', fontSize: 18);
  static TextStyle textHeaderStyleKhmerMoulLight14 = const TextStyle(fontFamily: 'Khmer OS Moul Light', fontSize: 14);
  static TextStyle textStyleKhmerContent = const TextStyle(fontFamily: 'NotoSans', fontSize: 14);
  static TextStyle textStyleKhmerContentWhite = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white);
  static TextStyle textStyleKhmerContentBlack = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.black);
  static TextStyle textStyleKhmerContentGrey = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.grey);
  static TextStyle textStyleKhmerContentAppBarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: StyleColor.appBarColor);
  static TextStyle textStyleKhmerContentBlue = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.blue);
  static TextStyle textStyleKhmerDangrek18 = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, inherit: false, color: Colors.black);
  static TextStyle textStyleKhmerDangrek18BlueGrey = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, inherit: false, color: Colors.blueGrey);
  static TextStyle textStyleKhmerDangrek18Bold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 18,
    inherit: false,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static TextStyle textStyleKhmerDangrek18White = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, inherit: false, color: Colors.white);
  static TextStyle textStyleKhmerDangrek18WhiteBold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 18,
    inherit: false,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static TextStyle textStyleKhmerDangrek18Grey = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, color: Colors.grey, inherit: false);
  static TextStyle textStyleKhmerDangrek20 = const TextStyle(fontFamily: 'NotoSans', fontSize: 20, inherit: false);
  static TextStyle textStyleKhmerDangrek20AppbarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 20, color: appBarColor, inherit: false);
  static TextStyle textStyleKhmerDangrek20White = const TextStyle(fontFamily: 'NotoSans', fontSize: 20, color: Colors.white, inherit: false);
  static TextStyle textStyleKhmerDangrek20WhiteBold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    inherit: false,
  );
  static TextStyle textStyleKhmerDangrek20BlackBold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    inherit: false,
  );
  static TextStyle textStyleKhmerDangrek20Black = const TextStyle(fontFamily: 'NotoSans', fontSize: 20, color: Colors.black, inherit: false);
  static TextStyle textStyleKhmerDangrekTitle30White = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    inherit: false,
  );
  static TextStyle textStyleKhmerDangrek18AppbarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 18, color: appBarColor, inherit: false);
  static TextStyle textStyleKhmerDangrek18Red = const TextStyle(fontFamily: 'NotoSans', fontSize: 18, color: Colors.red, inherit: false);

  static TextStyle textStyleKhmerDangrek14 = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.black, inherit: false);
  static TextStyle textStyleKhmerDangrek14Bold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    inherit: false,
  );
  static TextStyle textStyleKhmerDangrek14Grey = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.grey, inherit: false);
  static TextStyle textStyleKhmerDangrek14BlueGrey = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.blueGrey, inherit: false);
  static TextStyle textStyleKhmerDangrek14White = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white, inherit: false);
  static TextStyle textStyleKhmerDangrek14Red = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.red, inherit: false);
  static TextStyle textStyleKhmerDangrek14AppbarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: appBarColor, inherit: false);
  static TextStyle textStyleKhmerDangrek16 = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, inherit: false, color: Colors.black);
  static TextStyle textStyleKhmerDangrek16Bold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 16,
    inherit: false,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static TextStyle textStyleKhmerDangrek16Red = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, inherit: false, color: Colors.red);
  static TextStyle textStyleKhmerDangrek16AppbarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: appBarColor, inherit: false);
  static TextStyle textStyleKhmerDangrek16Grey = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.grey, inherit: false);
  static TextStyle textStyleKhmerDangrek16White = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.white, inherit: false);
  static TextStyle textStyleKhmerDangrek20AppBarColorBold = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: appBarColor,
    inherit: false,
  );
  static TextStyle textStyleKhmerContentBold({double? fontSize = 14, Color color = Colors.black}) {
    return TextStyle(fontFamily: 'NotoSans', fontSize: fontSize!.toDouble(), fontWeight: FontWeight.bold, color: color);
  }

  static TextStyle textStyleKhmerContent14Bold = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle textStyleKhmerContentBoldAppBar = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 14,
    color: StyleColor.appBarColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textStyleKhmerContentRed = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold);
  static TextStyle textStyleKhmerContent14 = const TextStyle(fontFamily: 'NotoSans', fontSize: 14);
  static TextStyle textStyleKhmerContent10 = const TextStyle(fontFamily: 'NotoSans', fontSize: 10);
  //12

  static TextStyle textStyleKhmerContent12 = const TextStyle(fontFamily: 'NotoSans', fontSize: 12);
  static TextStyle textStyleKhmerContent12Black = const TextStyle(fontFamily: 'NotoSans', fontSize: 12, color: Colors.black);
  static TextStyle textStyleKhmerContent12Grey = TextStyle(fontFamily: 'NotoSans', fontSize: 12, color: Colors.grey[700]);
  static TextStyle textStyleKhmerContent12Red = const TextStyle(fontFamily: 'NotoSans', fontSize: 12, color: Colors.red);
  static TextStyle textStyleKhmerContent12White = const TextStyle(fontFamily: 'NotoSans', fontSize: 12, color: Colors.white);
  static TextStyle textStyleKhmerContent12WhiteBold = const TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textStyleKhmerContent12AppBarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 12, color: appBarColor);
  static TextStyle textStyleKhmerContent12AppBarColorBold = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 12,
    color: appBarColor,
    fontWeight: FontWeight.bold,
  );
  //14

  static TextStyle textStyleKhmerContent14Grey = TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.grey[700]);
  static TextStyle textStyleKhmerContent14AppBarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: appBarColor);
  static TextStyle textStyleKhmerContent14Red = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.red);

  static TextStyle textStyleKhmerContent14Green = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.green);
  static TextStyle textStyleKhmerContent14Yellow = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Color.fromRGBO(254, 151, 5, 1));
  static TextStyle textStyleKhmerContent14Blue = TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: StyleColor.appBarColor);
  static TextStyle textStyleKhmerContent14Black = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.black);
  static TextStyle textStyleKhmerContent14Gold = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Color.fromRGBO(163, 141, 51, 1));
  static TextStyle textStyleKhmerContent14White = const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white);

  //16
  static TextStyle textStyleKhmerContent16AppbarColor = TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: StyleColor.appBarColor);
  static TextStyle textStyleKhmerContent16 = const TextStyle(fontFamily: 'NotoSans', fontSize: 16);
  static TextStyle textStyleKhmerContent16Bold = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle textStyleKhmerContent16White = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.white);
  static TextStyle textStyleKhmerContent16Black = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.black);
  static TextStyle textStyleKhmerContent16Grey = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.grey);
  static TextStyle textStyleKhmerContent16Red = const TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.red);

  static TextStyle textStyleKhmerContentAuto({int? fontSize = 14, Color color = Colors.black, bool bold = false}) {
    return TextStyle(
      fontFamily: 'NotoSans',
      fontSize: fontSize!.toDouble(),
      color: color,
      fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle textStyleKhmerDangrekAuto({int? fontSize = 14, Color color = Colors.black, bool bold = false, bool inherit = false}) {
    return TextStyle(
      fontFamily: 'NotoSans',
      fontSize: fontSize!.toDouble(),
      fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
      color: color,
      inherit: inherit,
    );
  }

  static TextStyle textStyleDefaultAuto({int? fontSize = 14, Color color = Colors.black, bool bold = false}) {
    return TextStyle(fontSize: fontSize!.toDouble(), fontWeight: bold == true ? FontWeight.bold : FontWeight.normal, color: color);
  }

  static TextStyle iconRegularAuto({int? fontSize = 14, Color color = Colors.black}) {
    return TextStyle(fontFamily: 'Fa-Regular', fontSize: fontSize!.toDouble(), color: color);
  }

  static TextStyle iconSolidAuto({int? fontSize = 14, Color color = Colors.black}) {
    return TextStyle(fontFamily: 'Fa-Solid', fontSize: fontSize!.toDouble(), color: color);
  }

  static TextStyle iconDuotoneAuto({int? fontSize = 14, Color color = Colors.black}) {
    return TextStyle(fontFamily: 'Fa-Duotone', fontSize: fontSize!.toDouble(), color: color);
  }

  static TextStyle txtStyleCustomFAS({Color color = Colors.grey, double fontSize = 12}) {
    return TextStyle(fontFamily: 'FAS', fontSize: fontSize.toDouble(), color: color);
  }

  static TextStyle txtStyleCustomFAR({Color color = Colors.grey, double fontSize = 12}) {
    return TextStyle(fontFamily: 'FAR', fontSize: fontSize.toDouble(), color: color);
  }

  static Widget getNoImage({Color? color, double size = 30}) {
    color ??= Colors.grey[200]!;
    return Center(
      child: Text(
        "\ue1b7",
        style: StyleColor.txtStyleCustomFAS(color: color, fontSize: size),
      ),
    );
  }

  static BoxShadow defaultShadow = const BoxShadow(color: Color.fromARGB(20, 99, 99, 99), blurRadius: 8, spreadRadius: 2);
  static TextStyle errorFormStyle = const TextStyle(color: Colors.red, fontSize: 14, fontFamily: 'NotoSans');

  static TextStyle textHeaderStyleCustom({Color color = Colors.grey, double fontSize = 12, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(fontFamily: 'NotoSans', fontSize: fontSize, color: color, fontWeight: fontWeight);
  }
}
