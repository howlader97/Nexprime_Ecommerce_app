import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_live_screen/widget/vendor_live_blur_container.dart';

class VendorLiveChatBox extends StatelessWidget {
  final List<Map<String, String>> messages;

  const VendorLiveChatBox({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: VendorLiveBlurContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: messages
                .map((msg) => VendorLiveChatItem(msg: msg))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class VendorLiveChatItem extends StatelessWidget {
  final Map<String, String> msg;

  const VendorLiveChatItem({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${msg['name']}: ",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            TextSpan(
              text: msg['message'],
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
