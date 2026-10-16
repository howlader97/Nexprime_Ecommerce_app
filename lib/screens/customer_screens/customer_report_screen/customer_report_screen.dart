import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/customer_screens/customer_report_screen/provider/report_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/buttons/app_button.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/inputs/app_input_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class CustomerReportScreen extends ConsumerStatefulWidget {
  const CustomerReportScreen({super.key});

  @override
  ConsumerState<CustomerReportScreen> createState() =>
      _CustomerReportScreenState();
}

class _CustomerReportScreenState extends ConsumerState<CustomerReportScreen> {
  final TextEditingController _othersController = TextEditingController();

  final List<String> _selectedReasons = [];

  final List<String> _reasons = [
    'Spam or scam',
    'Harassment or abuse',
    'Fake product',
    'Inappropriate content',
    'Other violation',
  ];

  @override
  void dispose() {
    _othersController.dispose();
    super.dispose();
  }

  void _toggleReason(String reason) {
    setState(() {
      if (_selectedReasons.contains(reason)) {
        _selectedReasons.remove(reason);
      } else {
        _selectedReasons.add(reason);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// ================= APP BAR =================
            SliverToBoxAdapter(
              child: CustomAppBar(
                backButton: () => Navigator.pop(context),
                title: "Report User",
              ),
            ),

            /// ================= BODY =================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(height: AppSize.size.width * 0.02),

                    AppText(
                      text:
                          "Select one or more reasons for reporting this user.",
                      fontSize: AppSize.size.width * 0.038,
                      color: Colors.grey,
                    ),

                    Gap(height: AppSize.size.width * 0.05),

                    /// ================= REASONS =================
                    AppText(
                      text: "Reasons",
                      fontSize: AppSize.size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),

                    Gap(height: AppSize.size.width * 0.03),

                    ..._reasons.map((reason) {
                      final isSelected = _selectedReasons.contains(reason);

                      return GestureDetector(
                        onTap: () => _toggleReason(reason),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: AppSize.size.width * 0.03,
                          ),
                          padding: EdgeInsets.all(AppSize.size.width * 0.03),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.instance.primary.withValues(
                                    alpha: 0.1,
                                  )
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.instance.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  text: reason,
                                  fontSize: AppSize.size.width * 0.04,
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                activeColor: AppColors.instance.primary,
                                onChanged: (_) => _toggleReason(reason),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    Gap(height: AppSize.size.width * 0.05),

                    /// ================= OTHERS =================
                    AppText(
                      text: "Others",
                      fontSize: AppSize.size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),

                    Gap(height: AppSize.size.width * 0.02),

                    AppInputWidget(
                      controller: _othersController,
                      hintText: "Write your reason...",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      style: TextStyle(color: Colors.black),
                      maxLines: 4,
                      minLines: 3,
                      fillColor: Colors.transparent,
                      borderColor: Colors.grey.shade300,
                      focusedBorderColor: AppColors.instance.primary,
                    ),

                    Gap(height: AppSize.size.width * 0.06),

                    /// ================= SUBMIT =================
                    AppButton(
                      height: AppSize.size.width * 0.12,
                      title: reportState is AsyncLoading
                          ? "Submitting..."
                          : "Submit Report",
                      backgroundColor: AppColors.instance.green,
                      borderColor: AppColors.instance.green,
                      onTap: reportState is AsyncLoading
                          ? null
                          : () {
                              ref
                                  .read(reportProvider.notifier)
                                  .submitReport(
                                    context: context,
                                    selectedReasons: _selectedReasons,
                                    othersText: _othersController.text,
                                  );
                            },
                    ),

                    // Gap(height: AppSize.size.width * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
