import 'package:flutter/material.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/app_size.dart';

class CustomerHomeMarketplaceWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomerHomeMarketplaceWidget({
    super.key,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
              onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.instance.grayEE,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.instance.grayE5,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.instance.green,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppText( text: 
                  "Marketplace",
                  style: TextStyle(
                    fontSize: AppSize.size.width*0.046,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
             
              const Icon(
                  Icons.arrow_forward,
                  size: 22,
                  color: Colors.black54,
                ),
            
            ],
          ),
        ),
      ),
    );
  }
}