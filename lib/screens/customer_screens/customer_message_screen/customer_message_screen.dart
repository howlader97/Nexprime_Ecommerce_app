import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/customer_screens/customer_home_screen/widgets/customer_home_search_bar.dart';
import 'package:nexprime/screens/customer_screens/customer_message_screen/provider/chat_active_users_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_profile_screen/provider/customer_profile_provider.dart';
import 'package:nexprime/screens/customer_screens/customer_message_screen/provider/chat_conversations_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

final chatMyProfileImageUrlProvider = Provider<String?>((ref) {
  final customerProfile = ref.watch(customerProfileProvider).value;
  if (customerProfile == null) return null;
  if (customerProfile.role.toUpperCase() == "VENDOR") {
    final vendorStore = ref.watch(vendorStoreProvider).value;
    return vendorStore?.photo ?? customerProfile.profileImageUrl;
  }
  return customerProfile.profileImageUrl;
});

final chatSearchQueryProvider = StateProvider<String>((ref) => '');

class CustomerMessageScreen extends ConsumerWidget {
  const CustomerMessageScreen({super.key});

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "";
    try {
      tz.initializeTimeZones();
      final utcTime = DateTime.parse(timeStr).toUtc();
      final japan = tz.getLocation('Asia/Tokyo');
      final jstTime = tz.TZDateTime.from(utcTime, japan);
      return DateFormat('hh:mm a').format(jstTime);
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUsersState = ref.watch(chatActiveUsersProvider);
    final conversationsState = ref.watch(chatConversationsProvider);
    final customerProfile = ref.watch(customerProfileProvider);
    final myProfileUrl = ref.watch(chatMyProfileImageUrlProvider);

    final activeUsers = activeUsersState.when(
      data: (data) => data,
      loading: () => [],
      error: (_, _) => [],
    );

    final onlineUsers = activeUsers;

    final allChattedUsers = conversationsState.when(
      data: (data) => data,
      loading: () => [],
      error: (_, _) => [],
    );

    final searchQuery = ref.watch(chatSearchQueryProvider).toLowerCase();

    final chattedUsers = allChattedUsers.where((u) {
      if (searchQuery.isEmpty) return true;
      final name = (u.fullname ?? "").toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(chatActiveUsersProvider);
            ref.invalidate(chatConversationsProvider);
            await Future.delayed(const Duration(milliseconds: 800));
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                    vertical: AppSize.size.width * 0.026,
                  ),
                  child: Row(
                    children: [
                      IconButtonWidget(
                        icon: Icons.arrow_back,
                        padding: 2,
                        onTap: () {
                          AppRoutes.instance.pop();
                        },
                      ),
                      Gap(width: 3),
                      AppText(
                        text: "Message",
                        fontSize: AppSize.size.width * 0.06,
                        color: AppColors.instance.black06,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(width: AppSize.size.width * 0.12),
                      Expanded(
                        child: CustomSearchBar(
                          hintText: "Search by name",
                          onChanged: (val) =>
                              ref.read(chatSearchQueryProvider.notifier).state =
                                  val,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child:
                    (activeUsersState.isLoading &&
                        activeUsers.isEmpty &&
                        customerProfile.value == null)
                    ? const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.size.width * 0.04,
                          vertical: AppSize.size.width * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (customerProfile.value != null)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.size.width * 0.008,
                                ),
                                child: Stack(
                                  children: [
                                    AppImageCircular(
                                      url:
                                          myProfileUrl ??
                                          'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg',
                                      width: AppSize.size.width * 0.15,
                                      height: AppSize.size.width * 0.15,
                                      borderColor: AppColors.instance.success,
                                      borderWidth: 1.5,
                                    ),
                                    Positioned(
                                      right: 2,
                                      bottom: 4,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: AppColors.instance.success,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ...onlineUsers.map((user) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.size.width * 0.008,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    AppRoutes.instance.pushNamed(
                                      AppRoutesKey.instance.customerChatScreen,
                                      extra: {
                                        "userId": user.userId,
                                        "name": user.fullname,
                                        "profileImageUrl": user.profileImageUrl,
                                        "showReport": false,
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      AppImageCircular(
                                        url:
                                            user.profileImageUrl ??
                                            'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg',
                                        width: AppSize.size.width * 0.15,
                                        height: AppSize.size.width * 0.15,
                                        borderColor: AppColors.instance.success,
                                        borderWidth: 1.5,
                                      ),
                                      Positioned(
                                        right: 2,
                                        bottom: 4,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: AppColors.instance.success,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size.width * 0.04,
                    vertical: AppSize.size.width * 0.04,
                  ),
                  child: AppText(
                    text: "Chats",
                    fontSize: AppSize.size.width * 0.06,
                    fontWeight: FontWeight.w600,
                    color: AppColors.instance.black06,
                  ),
                ),
              ),

              if (chattedUsers.isEmpty && !conversationsState.isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: AppText(
                        text: "No previous chats",
                        color: Colors.grey,
                        fontSize: AppSize.size.width * 0.04,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final chatUser = chattedUsers[index];
                    final bool hasUnread = chatUser.unreadCount > 0;
                    return InkWell(
                      onTap: () {
                        ref
                            .read(chatConversationsProvider.notifier)
                            .setActiveChatUser(chatUser.userId);
                        AppRoutes.instance
                            .pushNamed(
                              AppRoutesKey.instance.customerChatScreen,
                              extra: {
                                "userId": chatUser.userId,
                                "name": chatUser.fullname,
                                "profileImageUrl": chatUser.profileImageUrl,
                                "showReport": false,
                              },
                            )
                            .then((_) {
                              ref
                                  .read(chatConversationsProvider.notifier)
                                  .setActiveChatUser(null);
                            });
                      },
                      child: Container(
                        color: hasUnread
                            ? Colors.grey[200]
                            : Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.size.width * 0.04,
                          vertical: AppSize.size.width * 0.02,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                AppImageCircular(
                                  url:
                                      chatUser.profileImageUrl ??
                                      'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg',
                                  width: AppSize.size.width * 0.14,
                                  height: AppSize.size.width * 0.14,
                                  borderColor: AppColors.instance.success,
                                  borderWidth: 1.5,
                                ),
                                if (chatUser.isOnline)
                                  Positioned(
                                    right: 2,
                                    bottom: 2,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.instance.success,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Gap(width: AppSize.size.width * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: chatUser.fullname ?? 'User',
                                    fontSize: AppSize.size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.instance.black06,
                                  ),
                                  Gap(height: 4),
                                  AppText(
                                    text: chatUser.lastMessage ?? '',
                                    fontSize: AppSize.size.width * 0.035,
                                    color: AppColors.instance.gray50,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Time and Badge
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppText(
                                  text: _formatTime(chatUser.lastMessageTime),
                                  fontSize: AppSize.size.width * 0.03,
                                  color: AppColors.instance.gray50,
                                ),
                                Gap(height: 8),
                                if (chatUser.unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.instance.success,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      chatUser.unreadCount.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSize.size.width * 0.025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else
                                  SizedBox(height: AppSize.size.width * 0.05),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: chattedUsers.length),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
