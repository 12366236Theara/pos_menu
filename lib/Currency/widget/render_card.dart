import 'package:flutter/material.dart';
import 'package:pos_menu/Currency/model/currency_mode.dart';
import 'package:pos_menu/Extension/dynamic_icon_currency.dart';
import 'package:pos_menu/Infrastructor/styleColor.dart';

class RenderCurrencyWidget extends StatelessWidget {
  const RenderCurrencyWidget({super.key, this.onTapCard, this.data, this.trailing});
  final VoidCallback? onTapCard;

  final CurrencyModel? data;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(width: 1, color: Colors.grey),
            color: Colors.grey.shade300,
          ),
          child: Text(
            CurrencyExtention.currencyIconSecond(currencyCode: data?.dataCode),
            style: StyleColor.textStyleKhmerContentBlack.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        // leading: CachedNetworkImage(
        //     imageUrl: "${Domain.baseUrl}/${data?.image}",
        //     height: 50,
        //     width: 50,
        //     fit: BoxFit.contain,
        //     placeholder: (context, url) => const CircularProgressIndicator(),
        //     errorWidget: (context, url, error) => const NoImage()),
        title: Text(data?.dataName.toString() ?? "", style: StyleColor.textStyleKhmerDangrek20Black),
        subtitle: Text(data?.dataCode.toString() ?? ""),
        trailing: trailing,
        onTap: onTapCard,
      ),
    );
  }
}
