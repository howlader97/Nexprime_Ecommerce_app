
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/screens/customer_screens/customer_faq_screen/provider/faq_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';

import '../../../constant/app_colors.dart';
import '../../../widgets/texts/app_text.dart';

class CustomerFaqScreen extends ConsumerWidget {
  const CustomerFaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqAsync = ref.watch(faqProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () {
                  AppRoutes.instance.pop();
                },
                title: "FAQ",
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSize.size.width * 0.04),
                child: faqAsync.when(
                  data: (faqs) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: faqs.map((faq) => _FaqItem(
                      question: faq.question,
                      answer: faq.answer,
                      isInitialExpanded: faqs.indexOf(faq) == 0,
                    )).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text(e.toString())),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isInitialExpanded;

  const _FaqItem({
    required this.question,
    required this.answer,
    this.isInitialExpanded = false,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size.height * 0.012),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: const Color(0xffF1F4F1), // Light mint gray from image
            borderRadius: BorderRadius.circular(AppSize.size.width * 0.04),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSize.size.width * 0.045),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: widget.question,
                        fontSize: AppSize.size.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: AppColors.instance.black06,
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.instance.gray50,
                      size: AppSize.size.width * 0.07,
                    ),
                  ],
                ),
                ClipRect(
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    heightFactor: _isExpanded ? 1.0 : 0.0,
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSize.size.height * 0.01),
                      child: AppText(
                        text: widget.answer,
                        fontSize: AppSize.size.width * 0.038,
                        color: AppColors.instance.gray50,
                        height: 1.4,
                        maxLines: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

