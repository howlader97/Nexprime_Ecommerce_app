import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexprime/constant/app_colors.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/screens/vendor_screens/vendor_profile_screen/provider/vendor_profile_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_streaming_screen/provider/streaming_setup_provider.dart';
import 'package:nexprime/screens/vendor_screens/vendor_streaming_screen/provider/stream_provider.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_size.dart';
import 'package:nexprime/utils/gap.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

import '../../../widgets/image_userPick/image_user_pick.dart';

class VendorStreamingScreen extends ConsumerStatefulWidget {
  const VendorStreamingScreen({super.key});

  @override
  ConsumerState<VendorStreamingScreen> createState() =>
      _VendorStreamingScreenState();
}

class _VendorStreamingScreenState extends ConsumerState<VendorStreamingScreen> {
 late TextEditingController title = TextEditingController();
  final TextEditingController offerTEController = TextEditingController();

  void onAppClose(){
    try{
      title.dispose();
      offerTEController.dispose();
    }catch(e){
      errorLog("Error is", e);
    }
  }

  void _clearFields() {
    title.clear();
    offerTEController.clear();
    ref.read(streamingSetupProvider.notifier).reset();
  }
  @override
  void dispose() {
    onAppClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final size = MediaQuery.of(context).size;

    final vendorStore = ref.watch(vendorStoreProvider).value;
    final backgroundImageUrl = (vendorStore?.photo != null && vendorStore!.photo!.isNotEmpty)
        ? vendorStore.photo!
        : 'https://images.unsplash.com/photo-1540324155974-7523202daa3f?q=80&w=1000&auto=format&fit=crop';

    return Scaffold(
      backgroundColor: colors.black500,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              _buildBackground(size.height, backgroundImageUrl),
              _buildHeader(context, colors),
             // _buildMiddleControls(colors, size.height),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.6 - 32),
                child: _buildBottomContent(colors, size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(double height, String imageUrl) {
    return Container(
      height: height * 0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColors colors) {
    return Positioned(
      top: MediaQuery.of(context).padding.top > 0
          ? MediaQuery.of(context).padding.top + 16
          : 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // GestureDetector(
          //   child: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: colors.error,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: const Icon(Icons.close, color: Colors.white, size: 20),
          //   ),
          // ),
          // Status Pill
          Gap(width: 32,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: Colors.purple, size: 10),
                const SizedBox(width: 8),
                const AppText( text: 
                  'Not Live',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          // Gallery/Image icon
          GestureDetector(
            onTap: () {
              appImageUserTake(
                callBack: (path) {
                  ref.read(streamingSetupProvider.notifier).updateImage(File(path));
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(170),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBottomContent(AppColors colors, Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 48),
      decoration: BoxDecoration(
        color: colors.white100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Stream title',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.instance.black06,
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: title,
            style: TextStyle(color: AppColors.instance.black06),
            decoration: InputDecoration(
              hintText: 'What are you streaming today?',
              hintStyle: TextStyle(
                color: AppColors.instance.black06,
                fontSize: 13,
              ),
              filled: true,

              fillColor: colors.white200,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.grayE5, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.grayE5, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const AppText( text: 
            'Offer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
            decoration: BoxDecoration(
              color: colors.white200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.grayE5, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText( text: 
                      'Do you want to show your offer Button',
                      style: TextStyle(
                        color: AppColors.instance.black06,
                        fontSize: 12,
                      ),
                    ),
                    Switch(
                      value: ref.watch(streamingSetupProvider).isOfferEnabled,
                      onChanged: (val) {
                        ref.read(streamingSetupProvider.notifier).toggleOffer(val);
                      },
                      activeThumbColor: colors.success,
                      activeTrackColor: colors.success.withValues(alpha: 0.3),
                    ),
                  ],
                ),
                if (ref.watch(streamingSetupProvider).isOfferEnabled) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: offerTEController,
                    style: TextStyle(color: AppColors.instance.black06),
                    decoration: InputDecoration(
                      hintText: 'Enter offer details',
                      hintStyle: TextStyle(
                        color: AppColors.instance.black06,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: colors.white200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colors.grayE5,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colors.grayE5,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Consumer(
              builder: (context, ref, child) {
                final streamState = ref.watch(streamProvider);
                final isLoading = streamState is AsyncLoading;

                ref.listen(streamProvider, (previous, next) {
                  next.when(
                    data: (data) {
                      if (data != null) {
                          final token = data['token'];
                         final streamId=data['stream']['id'];
                         AppRoutes.instance.pushNamed(
                           AppRoutesKey.instance.vendorLiveScreen,
                           extra:{
                             'token':token,
                             'streamId':streamId,
                             'offer': offerTEController.text.trim(),
                           },

                         ).then((_) => _clearFields());
                      }
                    },
                    error: (e, st) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    },
                    loading: () {},
                  );
                });

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (title.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: AppText( text: "Please enter a title"),
                              ),
                            );
                            return;
                          }

                           ref
                              .read(streamProvider.notifier)
                              .startStream(
                                thumbnail: ref.read(streamingSetupProvider).selectedImage?.path,
                                title: title.text.trim(),
                                offer: offerTEController.text.trim(),
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.success,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const AppText( text: 
                          'Go Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
          ),
           Gap(height: AppSize.size.width * 0.13),
        ],
      ),
    );
  }
}


