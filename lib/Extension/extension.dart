import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Infrastructor/StyleColor.dart';
import 'package:pos_menu/widget/noImage.dart';
import '../Infrastructor/Singleton.dart';

enum DeviceTypes { PHONE, TABLET, DESKTOP }

enum DeviceScreenType { PORTRAIT, LANDSCAPE }

enum DurationStyle { short, long }

class Extension {
  static void clearFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // static DeviceTypess getDeviceTypes() {
  //   final data = MediaQueryData.fromView(
  //       WidgetsBinding.instance.platformDispatcher.views.single);
  //   return data.size.shortestSide < 600
  //       ? DeviceTypess.PHONE
  //       : DeviceTypess.TABLET;
  // }

  static Widget getNoImage() {
    return Image.asset('images/noimage.png');
  }

  static const mobile = 600;

  // static const table = 0;
  static const tablet = 1200;

  /// Returns a friendly duration name for a given number of days.
  /// Examples:
  ///  30  -> "Monthly"
  ///  365 -> "Yearly"
  ///  90  -> "Quarterly"
  ///  14  -> "Biweekly"
  ///  60  -> "Every 2 months"
  /// Fallbacks to "Every N weeks/months/days" when it doesn't match a common bucket.
  String planDurationName(int days) {
    if (days <= 0) return 'Custom';
    bool inRange(int min, int max) => days >= min && days <= max;

    if (days == 1) return 'Daily';
    if (days == 7) return 'Weekly';
    if (days == 14) return 'Biweekly';

    if (inRange(28, 31)) return 'Monthly';
    if (inRange(59, 62)) return 'Every 2 months'; // ~60 days
    if (inRange(89, 92)) return 'Quarterly'; // ~90 days
    if (inRange(179, 184)) return 'Semiannual'; // ~180 days
    if (inRange(364, 366)) return 'Yearly'; // 365 ± 1 (leap year)
    if (inRange(729, 732)) return 'Every 2 years'; // ~730 days

    // Try clean multiples
    if (days % 30 == 0) {
      final m = days ~/ 30;
      return m == 1 ? 'Monthly' : 'Every $m months';
    }
    if (days % 7 == 0) {
      final w = days ~/ 7;
      if (w == 2) return 'Biweekly';
      return w == 1 ? 'Weekly' : 'Every $w weeks';
    }

    return 'Every $days days';
  }

  static DeviceTypes getDeviceTypes({required BuildContext context}) {
    // final data = MediaQueryData.fromView(
    //     WidgetsBinding.instance.platformDispatcher.views.single);
    // return data.size.shortestSide < 600
    //     ? DeviceTypes.PHONE
    //     : data.size.shortestSide < 1400
    //         ? DeviceTypes.TABLET
    //         : DeviceTypes.DESKTOP;
    double shortestSide = MediaQuery.sizeOf(context).width;
    if (shortestSide < 600) {
      return DeviceTypes.PHONE;
    } else {
      // } else if (shortestSide >= 600 && shortestSide < 1200) {
      return DeviceTypes.TABLET;
    }
    //  else {
    //   return DeviceTypes.DESKTOP;
    // }
  }

  static Future<T?> showDialogs<T>({
    required BuildContext context,
    required String title,
    required Widget contentWidget,
    required Color backgroundColor,
    BoxConstraints? constraints,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final isPhone = size.width < 600;

        final dialogConstraint =
            constraints ??
            BoxConstraints(
              maxHeight: isPhone ? size.height * 0.65 : 650,
              minHeight: isPhone ? size.height * 0.5 : 650,
              maxWidth: isPhone ? size.width : 450,
              minWidth: isPhone ? size.width * 0.85 : 450,
            );

        return AlertDialog(
          backgroundColor: backgroundColor,
          insetPadding: isPhone ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24) : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          content: ConstrainedBox(
            constraints: dialogConstraint,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(bottom: BorderSide(color: StyleColor.mainColor.withOpacity(0.2), width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            title,
                            style: StyleColor.textStyleKhmerDangrek18White.copyWith(color: StyleColor.mainColor, fontSize: isPhone ? 16 : 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: StyleColor.mainColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(padding: EdgeInsets.all(isPhone ? 8.0 : 16.0), child: contentWidget),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFullImageDialog(BuildContext context, String imageUrl) {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return SizedBox(
    //         height: 400,
    //         width: 400,
    //         child: PhotoViewSlideOut(
    //           url: imageUrl,
    //         ),
    //       );
    //     });
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) {
            return Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            );
          },
          placeholder: (context, url) => const SizedBox(width: 300, height: 300, child: Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => const SizedBox(width: 300, height: 300, child: NoImage()),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Check user permission by [module_name] and [permission] if given
  /// if granted return [true] else return [false]
  static bool checkPermission(String module, {String? permission}) {
    if (Singleton.instance.userPreset?.userId == 1) {
      return true;
    }

    if (Singleton.instance.userPreset?.permissions != null) {
      var modules = Singleton.instance.userPreset!.permissions!.where((e) => e.module == module);
      if (modules.isNotEmpty) {
        if (permission != null) {
          var permissions = modules.where((e) => e.permission == permission);
          return permissions.isNotEmpty;
        } else {
          return true;
        }
      }
    }
    return false;
  }

  String khmerRieldConvert(dynamic number) {
    var res = NumberFormat.currency(locale: 'km_KH', symbol: '', decimalDigits: 0).format(number);
    return res;
  }

  int convertKhmerRielToNumber(String formattedNumber) {
    String cleanNumber = formattedNumber.replaceAll(',', '');

    return int.parse(cleanNumber);
  }

  String convertStringToDate(String dateString) {
    log("Date String: $dateString");
    if (dateString.contains("-")) {
      return dateString;
    }
    DateTime parsedDate = DateFormat("MM/dd/yyyy").parseStrict(dateString);
    String formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);
    return formattedDate;
  }

  DateTime convertStringToDateTime(String dateString) {
    log("Passed Date String: $dateString");
    if (dateString.contains("-")) {
      return DateFormat("dd-MM-yyyy").parseStrict(dateString);
    }
    List<String> parts = dateString.split('/');
    String reformattedDate = '${parts[1]}-${parts[0]}-${parts[2]}';
    DateTime parsedDate = DateFormat("dd-MM-yyyy").parseStrict(reformattedDate);
    return parsedDate;
  }

  String getImageResizeUrl(String url, String query) {
    return "${Domain.baseUrl}${Domain.IMAGE_RESIZE}$url";
  }

  String formatDurationReadable(Duration d, {String? locale, DurationStyle style = DurationStyle.long, int maxUnits = 2}) {
    final lang = locale ?? Intl.getCurrentLocale();
    final nf = NumberFormat.decimalPattern(lang);

    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    const longLabels = {
      'en': {
        'd': ['day', 'days'],
        'h': ['hour', 'hours'],
        'm': ['minute', 'minutes'],
        's': ['second', 'seconds'],
      },
      // Khmer: no plural inflection
      'km': {
        'd': ['ថ្ងៃ', 'ថ្ងៃ'],
        'h': ['ម៉ោង', 'ម៉ោង'],
        'm': ['នាទី', 'នាទី'],
        's': ['វិនាទី', 'វិនាទី'],
      },
    };

    const shortLabels = {
      'en': {'d': 'd', 'h': 'h', 'm': 'm', 's': 's'},
      'km': {'d': 'ថ្ងៃ', 'h': 'ម៉ោង', 'm': 'នាទី', 's': 'វិនាទី'},
    };

    String label(String unit, int value) {
      if (style == DurationStyle.short) {
        return (shortLabels[lang] ?? shortLabels['en']!)[unit]!;
      } else {
        final pairs = (longLabels[lang] ?? longLabels['en']!)[unit]!;
        return value == 1 ? pairs[0] : pairs[1];
      }
    }

    final parts = <String>[];
    if (days > 0) parts.add('${nf.format(days)} ${label('d', days)}');
    if (hours > 0) parts.add('${nf.format(hours)} ${label('h', hours)}');
    if (minutes > 0) parts.add('${nf.format(minutes)} ${label('m', minutes)}');
    if (seconds > 0 && parts.isEmpty) {
      // only show seconds if everything else is zero
      parts.add('${nf.format(seconds)} ${label('s', seconds)}');
    }

    if (parts.isEmpty) {
      return style == DurationStyle.short ? '0${(shortLabels[lang] ?? shortLabels['en']!)['m']}' : '0 ${label('m', 0)}';
    }

    final trimmed = parts.take(maxUnits).toList();
    return style == DurationStyle.short ? trimmed.join(' ') : trimmed.join(', ');
  }
}
