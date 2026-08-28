import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/provider/stream_notification_provider.dart';
import 'package:nexprime/services/repository/stream_repository.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/custom_app_bar.dart';
import 'package:nexprime/widgets/buttons/custom_decorated_box.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';

class CustomerNotificationScreen extends ConsumerWidget {
  const CustomerNotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(streamNotificationProvider);
    final streams = notification.value;
    if (streams != null) {
      for (var streams in streams) {
        appLog("stream id ${streams.id}");
      }
    }
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(streamNotificationProvider.notifier)
                .getNotification();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: CustomAppBar(
                  backButton: () {
                    AppRoutes.instance.pop();
                  },
                  title: "Notifications",
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                  ),
                  child: AppText(
                    text: "Today",
                    fontSize: AppSize.size.width * 0.055,
                    color: AppColors.instance.black06,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                ),
                sliver: notification.when(
                  data: (streamNotification) {
                    if (streamNotification.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: AppText( text: 
                            "No notification available",
                            style: TextStyle(
                              color: AppColors.instance.black06,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList.builder(
                      itemCount: streamNotification.length,
                      itemBuilder: (context, index) {
                        final notificationData = streamNotification[index];
                        return GestureDetector(
                          onTap: () async {
                            try {
                              // Fetch join token
                              final joinData = await StreamingRepository.instance
                                  .joinStream(streamId: notificationData.id);

                              if (joinData != null && joinData['token'] != null) {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.vendorLiveScreen,
                                  extra: {
                                    'token': joinData['token'],
                                    'streamId': notificationData.id,
                                    'isHost': false,
                                    'shopName': notificationData.storeName,
                                    'shopPhoto': notificationData.thumbnail,
                                    'offer': notificationData.offer,
                                  },
                                );
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Failed to join stream."),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              debugPrint("Error joining stream: $e");
                            }
                          },
                          child: CustomDecoratedBox(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSize.size.width * 0.06,
                              ),
                              child: ListTile(
                                leading: AppImageCircular(
                                  height: AppSize.height(value: 60),
                                  width: AppSize.width(value: 58),
                                  url: notificationData.thumbnail,
                                ),

                                title: AppText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: notificationData.title,
                                  fontSize: AppSize.size.width * 0.04,
                                  color: AppColors.instance.black06,
                                  fontWeight: FontWeight.w600,
                                ),
                                subtitle: AppText(
                                  text:
                                      notificationData.description ??
                                      "this product streaming from vendor side",
                                  fontSize: AppSize.size.width * 0.03,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.instance.black06,
                                  fontWeight: FontWeight.w400,
                                ),
                                trailing: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.instance.green,
                                  ),
                                  child: SizedBox(height: 15, width: 15),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (e, _) {
                    return SliverToBoxAdapter(child: AppText( text: e.toString()));
                  },
                  loading: () {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
