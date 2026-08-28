import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'dart:ui';
import 'dart:math';

import 'package:nexprime/screens/vendor_screens/vendor_live_screen/provider/vendor_live_provider.dart';
import 'package:nexprime/widgets/texts/app_text.dart';

class VendorLiveScreen extends ConsumerStatefulWidget {
  final String token;
  final int streamId;
  final bool isHost;
  final String shopName;
  final String shopPhoto;
  final String offer;

  const VendorLiveScreen({
    super.key,
    required this.token,
    required this.streamId,
    this.isHost = true,
    this.shopName = 'Shop',
    this.shopPhoto = '',
    this.offer = '',
  });

  @override
  ConsumerState<VendorLiveScreen> createState() => _VendorLiveScreenState();
}

class _VendorLiveScreenState extends ConsumerState<VendorLiveScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isOfferVisible = false;
  final List<Widget> _hearts = [];
  int _heartIdCounter = 0;

  void _showFloatingHeart() {
    final id = _heartIdCounter++;
    if (mounted) {
      setState(() {
        _hearts.add(_FloatingHeart(
          key: ValueKey(id),
          onComplete: () {
            if (mounted) {
              setState(() {
                _hearts.removeWhere((h) => (h.key as ValueKey).value == id);
              });
            }
          },
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(vendorLiveProvider.notifier)
          .initAndConnect(widget.token, isHost: widget.isHost);
    });
  }

  void _onClosePressed() {
    if (widget.isHost) {
      ref
          .read(vendorLiveProvider.notifier)
          .stopStream(
            widget.streamId,
            onStopped: () {
              if (mounted) Navigator.pop(context);
            },
          );
    } else {
      ref.read(vendorLiveProvider.notifier).disconnect().then((_) {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      ref.read(vendorLiveProvider.notifier).sendComment(text);
      _commentController.clear();
      // Smooth scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<VendorLiveState>(vendorLiveProvider, (previous, next) {
      if (previous != null) {
        if (previous.messages.length < next.messages.length) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients && mounted) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
        if (previous.likeEventCount < next.likeEventCount) {
          _showFloatingHeart();
        }
      }
    });

    final liveState = ref.watch(vendorLiveProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildVideoBackground(liveState),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: widget.isHost
                ? _buildHostHeader(liveState)
                : _buildTopHeader(liveState),
          ),

          Positioned(left: 16, bottom: 320, child: _buildViewOfferOverlay()),

          // Floating Hearts Overlay
          ..._hearts,

          // 5. Bottom Controls & Chat
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: widget.isHost
                ? _buildHostBottomSection(liveState)
                : _buildBottomSection(liveState),
          ),

          // 6. Stream Ended Overlay
          if (liveState.isStreamEnded && !widget.isHost)
            _buildStreamEndedOverlay(),

          if (liveState.isConnecting)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildVideoBackground(VendorLiveState state) {
    if (state.isHost) {
      if (state.localVideoTrack != null && state.isCameraOn) {
        return SizedBox.expand(
          child: VideoTrackRenderer(
            state.localVideoTrack!,
            fit: VideoViewFit.cover,
          ),
        );
      }
    } else {
      if (state.remoteVideoTrack != null) {
        return SizedBox.expand(
          child: VideoTrackRenderer(
            state.remoteVideoTrack!,
            fit: VideoViewFit.cover,
          ),
        );
      }
    }
    return Container(
      color: Colors.black87,
      child: const Center(
        child: AppText( text: 
          "Waiting for Host...",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

  String _formatViewerCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  Widget _buildHostHeader(VendorLiveState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildBadge('Live', const Color(0xFFB330F2)),
            const SizedBox(width: 8),
            _buildBadge(_formatViewerCount(state.viewerCount), const Color(0xFF2E8B57), icon: Icons.visibility),
          ],
        ),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildBadge(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:  0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          AppText( text: 
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(VendorLiveState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(widget.shopPhoto),
                          backgroundColor: Colors.grey[800],
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: AppText( text: 
                            widget.shopName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB330F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const AppText( text: 
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: _onClosePressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildViewOfferOverlay() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.offer.isNotEmpty && _isOfferVisible)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: AppText( text: 
              widget.offer,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isOfferVisible = !_isOfferVisible;
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:widget.offer.isEmpty? Colors.transparent: Colors.black.withValues(alpha: 0.4),
                  border: Border.all(color:widget.offer.isEmpty?Colors.transparent: Colors.white24),
                ),
                child: AppText( text: 
                  widget.offer.isEmpty
                      ? ''
                      : (_isOfferVisible ? 'Hide Offer' : 'View Offer'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHostBottomSection(VendorLiveState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Message list for host with clear background
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 250,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black],
                  stops: [0.0, 0.2, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: RichText(
                        text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${msg.senderName}: ',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: msg.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration:  BoxDecoration(color: Color(0xFF4C9E57),borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (_) => _sendComment(),
                          ),
                        ),
                        GestureDetector(
                          onTap: _sendComment,
                          child: const Icon(
                            Icons.send,
                            color: Color(0xFF4C9E57),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildSmallIconButton(
                  Icons.camera_alt,
                  state.isCameraOn,
                  () => ref.read(vendorLiveProvider.notifier).toggleCamera(),
                ),
                const SizedBox(width: 8),
                _buildSmallIconButton(
                  Icons.mic,
                  state.isMicOn,
                  () => ref.read(vendorLiveProvider.notifier).toggleMic(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallIconButton(
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isActive ? icon : Icons.block,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildBottomSection(VendorLiveState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black],
                  stops: [0.0, 0.2, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: RichText(
                        text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${msg.senderName}: ',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: msg.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Say something...',
                                hintStyle: TextStyle(color: Colors.black),
                                // border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendComment(),
                            ),
                          ),
                          GestureDetector(
                            onTap: _sendComment,
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Color(0xFFB330F2),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // _buildCircularIcon(Icons.share, Colors.white.withValues(alpha: 0.2)),
              // const SizedBox(width: 8),
              GestureDetector(
                onTap: () => ref.read(vendorLiveProvider.notifier).sendLike(),
                child: _buildCircularIcon(
                  Icons.favorite,
                  Colors.white.withValues(alpha: 0.2),
                  iconColor: Colors.pinkAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCircularIcon(
    IconData icon,
    Color bgColor, {
    Color iconColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildStreamEndedOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.live_tv, color: Colors.white, size: 80),
              const SizedBox(height: 20),
              const AppText( text: 
                'Stream ended by host',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB330F2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const AppText( text: 
                  'Exit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingHeart extends StatefulWidget {
  final VoidCallback onComplete;

  const _FloatingHeart({super.key, required this.onComplete});

  @override
  State<_FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<_FloatingHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  final double _randomX = -30 + (Random().nextDouble() * 60);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _positionAnimation = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward().whenComplete(() => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: 80 + _positionAnimation.value,
          right: 32 + _randomX,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: const Icon(Icons.favorite,
                color: Colors.pinkAccent, size: 36),
          ),
        );
      },
    );
  }
}

