import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/base_screen/faq_screen/providers/f_a_q_screen_provider.dart';
import 'package:nexprime/screens/base_screen/faq_screen/widgets/faq_card.dart';
import 'package:nexprime/screens/base_screen/faq_screen/widgets/faq_card_loader.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/texts/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppSize.size.width * 0.2,
        leading: InkWell(
          onTap: () {
            AppRoutes.instance.pop();
          },
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: AppSize.size.width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.width(value: 10)),
              color: AppColors.instance.green,
            ),
            child: Icon(Icons.arrow_back, color: AppColors.instance.white50),
          ),
        ),
        centerTitle: true,
        title: AppText(
          text: "FAQ",
          fontSize: AppSize.size.width * 0.08,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.size.width * 0.05),
        child: Consumer(
          builder: (context, ref, child) {
            var provider = ref.watch(fAQScreenProvider);
            return provider.when(
              data: (data) {
                if (data.isEmpty) return SizedBox();
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var item = data[index];
                    return FaqCard(
                      item: item,
                      onTap: () {
                        ref.read(fAQScreenProvider.notifier).changeItem(index);
                      },
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(child: AppText(text: "Something Was Wrong"));
              },
              loading: () => Skeletonizer(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return FaqCardLoader();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
