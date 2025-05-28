
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../utils/dimensions.dart';
// import '../utils/textstyles.dart';
// class CustomApp extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final bool isBackButtonExist;
//   final Function? onBackPressed;
//   final Widget? menuWidget;
//   final Function()? isBackCall;

//   const CustomApp({Key? key, required this.title, this.onBackPressed, this.isBackButtonExist = false, this.menuWidget,  this.isBackCall, }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(title!, style: openSansRegular.copyWith(fontSize: Dimensions.fontSize18, color: Colors.white)).tr(),
//       centerTitle: true,
//       leading: isBackButtonExist ? IconButton(
//         icon: const Icon(Icons.arrow_back),
//         color: Colors.white,
//         onPressed: () {
//           if (isBackCall != null) {
//             isBackCall!();
//           } else {
//             Navigator.pop(context);
//           }
//         },
//       ):  Builder(
//         builder: (context) => InkWell(
//           onTap: () {
//             Scaffold.of(context).openDrawer();
//           },
//           child: Container(
//             padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
//             child: Icon(
//               Icons.menu,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//         ),),

//       backgroundColor: Theme.of(context).primaryColor,
//       elevation: 0,
//       actions: menuWidget != null ? [Padding(
//         padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
//         child: menuWidget!,
//       )] : null,
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(60);
// }
