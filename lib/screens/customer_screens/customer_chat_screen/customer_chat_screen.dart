import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/models/marketing_product_model.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/models/chat_history_model.dart';
import 'package:nexprime/screens/customer_screens/customer_chat_screen/provider/chat_messages_provider.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/app_image/app_image_circular.dart';
import 'package:nexprime/widgets/buttons/icon_button_widget.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../customer_report_screen/provider/report_data_provider.dart';

class CustomerChatScreen extends ConsumerStatefulWidget {
  final int userId;
  final String name;
  final String profileImageUrl;
  final MarketingProductModel? product;
  final bool showReport;

  const CustomerChatScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.profileImageUrl,
    required this.product,
    this.showReport =false,
  });

  @override
  ConsumerState<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends ConsumerState<CustomerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    ref
        .read(chatMessagesProvider(widget.userId).notifier)
        .sendTextMessage(_messageController.text);
    _messageController.clear();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30, // Extremely fast compression
      maxWidth: 1024,
    );
    if (image != null) {
      File file = File(image.path);
      ref
          .read(chatMessagesProvider(widget.userId).notifier)
          .sendImageMessage(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesState = ref.watch(chatMessagesProvider(widget.userId));
    final messagesAsync = messagesState.messages;

    return Scaffold(
      backgroundColor: AppColors.instance.white50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // New messages at the bottom
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.size.width * 0.04,
                      vertical: 20,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      // Determine if it's me based on receiverId (if I am sender, receiverId is the other guy)
                      // This assumes backend logic. Replace with `widget.userId != message.senderId` if needed
                      final isMe = message.senderId != widget.userId;
                      return _buildMessageBubble(
                        message,
                        isMe,
                        index,
                        messages.length,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    Center(child: Text('Error loading messages')),
              ),
            ),

            // Reply Preview
            if (messagesState.replyingToMessage != null)
              _buildReplyPreview(messagesState.replyingToMessage!),

            // Message Input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyPreview(ChatHistoryModel message) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.04,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        border: Border(
          left: BorderSide(
            color: AppColors.instance.success,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: message.senderId == widget.userId ? widget.name : "You",
                  fontSize: AppSize.size.width * 0.035,
                  fontWeight: FontWeight.bold,
                  color: AppColors.instance.success,
                ),
                AppText(
                  text: message.type == "IMAGE" ? "Photo" : (message.content ?? ""),
                  fontSize: AppSize.size.width * 0.035,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () {
              ref
                  .read(chatMessagesProvider(widget.userId).notifier)
                  .setReplyingTo(null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.chat_bubble_outline,
          size: 60,
          color: Colors.grey.withValues(alpha: 0.5),
        ),
        const Gap(height: 16),
        AppText(
          text: "No messages yet",
          fontSize: AppSize.size.width * 0.045,
          color: Colors.grey,
        ),
        AppText(
          text: "Start the conversation by typing below!",
          fontSize: AppSize.size.width * 0.035,
          color: Colors.grey.withValues(alpha: 0.7),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.04,
        vertical: AppSize.size.width * 0.02,
      ),
      child: Row(
        children: [
          IconButtonWidget(
            onTap: () => Navigator.pop(context),
            icon: Icons.arrow_back,
          ),
          Gap(width: AppSize.size.width * 0.03),
          Stack(
            children: [
              AppImageCircular(
                url: widget.profileImageUrl,
                width: AppSize.size.width * 0.11,
                height: AppSize.size.width * 0.11,
                borderColor: AppColors.instance.success,
                borderWidth: 1,
              ),
              Positioned(
                right: 0,
                bottom: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.instance.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          Gap(width: AppSize.size.width * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: widget.name,
                  fontSize: AppSize.size.width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text: "Online",
                  fontSize: AppSize.size.width * 0.035,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          widget.showReport?
          GestureDetector(
            onTap: () {
              ref.read(reportDataProvider.notifier).state = ReportArgs(
                userId: widget.userId,
                product: widget.product,
              );
              AppRoutes.instance.pushNamed(
                AppRoutesKey.instance.customerReportScreen,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size.width * 0.03,
                vertical: AppSize.size.width * 0.018,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const AppText(
                text: "Report",
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ): const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    dynamic message,
    bool isMe,
    int index,
    int totalLength,
  ) {
    final parentMessageId = message.replyToId;
    ChatHistoryModel? parentMessage;
    if (parentMessageId != null) {
      ref.read(chatMessagesProvider(widget.userId)).messages.whenData((msgs) {
        try {
          parentMessage = msgs.firstWhere((m) => m.id == parentMessageId);
        } catch (_) {}
      });
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          ref
              .read(chatMessagesProvider(widget.userId).notifier)
              .setReplyingTo(message);
        },
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              AppImageCircular(
                url: widget.profileImageUrl,
                width: 32,
                height: 32,
                borderColor: AppColors.instance.success,
                borderWidth: 1,
              ),
              Gap(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (message.type == "IMAGE" && message.content != null)
                    Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (parentMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                left: BorderSide(
                                  color: AppColors.instance.success,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: parentMessage!.senderId == widget.userId
                                      ? widget.name
                                      : "You",
                                  fontSize: AppSize.size.width * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.instance.success,
                                ),
                                AppText(
                                  text: parentMessage!.type == "IMAGE"
                                      ? "Photo"
                                      : (parentMessage!.content ?? ""),
                                  fontSize: AppSize.size.width * 0.03,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        Container(
                          width: AppSize.size.width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(message.content!, fit: BoxFit.cover),
                        ),
                      ],
                    )
                  else if (message.content != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppColors.instance.success
                            : const Color(0xff414446),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (parentMessage != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                  left: BorderSide(
                                    color: isMe ? Colors.white : AppColors.instance.success,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: parentMessage!.senderId == widget.userId ? widget.name : "You",
                                    fontSize: AppSize.size.width * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: isMe ? Colors.white70 : AppColors.instance.success,
                                  ),
                                  AppText(
                                    text: parentMessage!.type == "IMAGE" ? "Photo" : (parentMessage!.content ?? ""),
                                    fontSize: AppSize.size.width * 0.03,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: isMe ? Colors.white60 : Colors.grey[300],
                                  ),
                                ],
                              ),
                            ),
                          AppText(
                            text: message.content!,
                            color: Colors.white,
                            fontSize: AppSize.size.width * 0.038,
                          ),
                        ],
                      ),
                    ),
                  Gap(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.04,
        vertical: AppSize.size.width * 0.02,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size.width * 0.04,
          vertical: AppSize.size.width * 0.01,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF1F4F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                  fontSize: AppSize.size.width * 0.038,
                  color: AppColors.instance.black06,
                ),
                decoration: InputDecoration(
                  hintText: "Say something.......",
                  hintStyle: TextStyle(
                    color: AppColors.instance.black06,
                    fontSize: AppSize.size.width * 0.038,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.attach_file,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: _pickImage,
            ),

            Gap(width: AppSize.size.width * 0.001),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.send_outlined,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
