import 'package:astrowaypartner/widgets/sizedboxes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/nativeTheme.dart';
import '../utils/textstyles.dart';

class CustomProfileDataContainer extends StatelessWidget {
  final String title;
  final String data;
  const CustomProfileDataContainer(this.title, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
        decoration: BoxDecoration(color: whiteBgColor,
        borderRadius: BorderRadius.circular(12)
        
    ),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(textAlign: TextAlign.center,
            title,
            style: openSansSemiBold,
          ).tr(),
          const SizedBox(height: 10,),
          Text(textAlign: TextAlign.center,
            data,
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          )
        ],
      )


      // ListTile(
      //   enabled: true,
      //   tileColor: Colors.white,
      //   title: Text(
      //     title,
      //     style: openSansRegular,
      //   ).tr(),
      //   trailing: Text(  maxLines: 1,overflow: TextOverflow.ellipsis,
      //     data,
      //     style: Theme.of(context).primaryTextTheme.bodyMedium,
      //   ),
      // ),
    );
  }
}
