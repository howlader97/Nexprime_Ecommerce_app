import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_action_buttons.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_app_bar.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_custom_body.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_edit_body.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/widget/vendor_profile_popular_products.dart';
import 'package:nexprime/screens/vendor_screens/vendor_review_screen/vendor_review_screen.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/widgets/stripe_connect_card.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  bool isClicked = true;

  @override
  Widget build(BuildContext context) {
    final vendorStoreAsync = ref.watch(vendorStoreProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(vendorStoreProvider.notifier).fetchVendorStoreData();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Top Cover & Profile Avatar App Bar
              VendorProfileAppBar(vendorStoreAsync: vendorStoreAsync),

              // Message & More Action Buttons
              const SliverToBoxAdapter(
                child: VendorProfileActionButtons(),
              ),

              // Profile Bio & Stats Body
              if (isClicked)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.size.height * 0.015),
                    child: vendorStoreAsync.when(
                      data: (vendorStore) {
                        final likesValue = vendorStore != null
                            ? ref.watch(vendorLikesProvider(vendorStore.id)).value
                            : 0;
                        return VendorProfileCustomBody(
                          vendorStore: vendorStore,
                          likes: likesValue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VendorReviewScreen()),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text(e.toString())),
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: VendorProfileEditBody(
                    vendorStore: vendorStoreAsync.value,
                    onSave: () {
                      setState(() {
                        isClicked = true;
                      });
                    },
                  ),
                ),

              // Stripe Connect Card
              if (isClicked)
                const SliverToBoxAdapter(
                  child: StripeConnectCard(),
                ),

              // Popular Products Section
              if (isClicked)
                VendorProfilePopularProducts(vendorStoreAsync: vendorStoreAsync),
            ],
          ),
        ),
      ),
    );
  }
}
