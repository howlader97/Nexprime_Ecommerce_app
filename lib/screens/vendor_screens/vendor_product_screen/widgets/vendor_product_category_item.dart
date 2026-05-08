// import 'package:flutter/material.dart';
// import 'package:nexprime/utils/gap.dart';
//
// import '../../../../constant/app_colors.dart';
// import '../../../../utils/app_size.dart';
// import '../../../../widgets/app_image/app_image.dart';
// import '../../../../widgets/texts/app_text.dart';
//
// class VendorProductCategoryItem extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//
//   const VendorProductCategoryItem({
//     super.key,
//     required this.title,
//     required this.isSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(right: AppSize.size.width * 0.02),
//       child: Container(
//         height: AppSize.size.height * 0.11,
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppColors.instance.dark100
//               : AppColors.instance.dark50,
//           borderRadius: BorderRadius.circular( AppSize.width(value: 8)),
//         ),
//
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: AppSize.size.height * 0.01,
//             horizontal: AppSize.size.width * 0.02,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 height: AppSize.size.height * 0.060,
//                 width: AppSize.size.width * 0.17,
//                 decoration: BoxDecoration(
//                   color: AppColors.instance.white50,
//                   borderRadius: BorderRadius.circular( AppSize.width(value: 4)),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular( AppSize.width(value: 4)),
//                   child: AppImage(
//                     path: "assets/dev_image/product1.png",
//                     height: AppSize.size.height * 0.48,
//                     width: AppSize.size.width * 0.8,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const Gap(height: 6),
//               AppText(
//                 text: title,
//                 textAlign: TextAlign.center,
//                 fontSize: AppSize.width(value: 12),
//                 height: 1.5,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }