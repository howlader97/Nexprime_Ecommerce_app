import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:nexprime/screens/vendor_screens/vendor_streaming_screen/provider/stop_stream_provider.dart';

class LiveMessage {
  final String senderName;
  final String text;
  final bool isHost;
  final DateTime timestamp;

  LiveMessage({
    required this.senderName,
    required this.text,
    this.isHost = false,
    required this.timestamp,
  });
}

class VendorLiveState {
  final Room? room;
  final LocalVideoTrack? localVideoTrack;
  final RemoteVideoTrack? remoteVideoTrack;
  final bool isHost;
  final bool isCameraOn;
  final bool isMicOn;
  final bool isConnecting;
  final String? error;
  final List<LiveMessage> messages;
  final int viewerCount;
  final int likeEventCount;
  final bool isStreamEnded;

  VendorLiveState({
    this.room,
    this.localVideoTrack,
    this.remoteVideoTrack,
    this.isHost = true,
    this.isCameraOn = true,
    this.isMicOn = true,
    this.isConnecting = false,
    this.error,
    this.messages = const [],
    this.viewerCount = 0,
    this.likeEventCount = 0,
    this.isStreamEnded = false,
  });

  VendorLiveState copyWith({
    Room? room,
    LocalVideoTrack? localVideoTrack,
    RemoteVideoTrack? remoteVideoTrack,
    bool? isHost,
    bool? isCameraOn,
    bool? isMicOn,
    bool? isConnecting,
    String? error,
    List<LiveMessage>? messages,
    int? viewerCount,
    int? likeEventCount,
    bool? isStreamEnded,
    bool? clearError = false,
  }) {
    return VendorLiveState(
      room: room ?? this.room,
      localVideoTrack: localVideoTrack ?? this.localVideoTrack,
      remoteVideoTrack: remoteVideoTrack ?? this.remoteVideoTrack,
      isHost: isHost ?? this.isHost,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMicOn: isMicOn ?? this.isMicOn,
      isConnecting: isConnecting ?? this.isConnecting,
      error: clearError == true ? null : (error ?? this.error),
      messages: messages ?? this.messages,
      viewerCount: viewerCount ?? this.viewerCount,
      likeEventCount: likeEventCount ?? this.likeEventCount,
      isStreamEnded: isStreamEnded ?? this.isStreamEnded,
    );
  }
}

final vendorLiveProvider =
    StateNotifierProvider.autoDispose<VendorLiveNotifier, VendorLiveState>((
      ref,
    ) {
      return VendorLiveNotifier(ref);
    });

class VendorLiveNotifier extends StateNotifier<VendorLiveState> {
  final Ref _ref;
  final String liveKitUrl = "wss://nexprime-4arisltx.livekit.cloud";

  VendorLiveNotifier(this._ref) : super(VendorLiveState());

  Future<void> initAndConnect(String token, {bool isHost = true}) async {
    try {
      state = state.copyWith(
        isConnecting: true,
        clearError: true,
        isHost: isHost,
      );

      LocalVideoTrack? track;
      if (isHost) {
        // Only initialize camera if host
        track = await LocalVideoTrack.createCameraTrack(
          const CameraCaptureOptions(cameraPosition: CameraPosition.front),
        );
        state = state.copyWith(localVideoTrack: track);
      }

      // 2. Connect
      final room = Room();
      final listener = room.createListener();

      // Setup listeners BEFORE connecting to catch all events
      listener.on<TrackSubscribedEvent>((event) {
        if (event.track is RemoteVideoTrack) {
          state = state.copyWith(
            remoteVideoTrack: event.track as RemoteVideoTrack,
          );
        }
      });

      listener.on<ParticipantConnectedEvent>((_) {
        state = state.copyWith(viewerCount: room.remoteParticipants.length);
      });

      listener.on<ParticipantDisconnectedEvent>((_) {
        state = state.copyWith(viewerCount: room.remoteParticipants.length);
      });

      listener.on<DataReceivedEvent>((event) {
        try {
          final String data = utf8.decode(event.data);
          final Map<String, dynamic> json = jsonDecode(data);

          if (json['type'] == 'chat') {
            final newMessage = LiveMessage(
              senderName: json['senderName'] ?? 'Guest',
              text: json['text'] ?? '',
              isHost: json['isHost'] ?? false,
              timestamp: DateTime.now(),
            );
            state = state.copyWith(messages: [...state.messages, newMessage]);
          } else if (json['type'] == 'like') {
            state = state.copyWith(likeEventCount: state.likeEventCount + 1);
          } else if (json['type'] == 'stream_ended') {
            state = state.copyWith(isStreamEnded: true);
          }
        } catch (e) {
          debugPrint("Error parsing data packet: $e");
        }
      });

      listener.on<RoomDisconnectedEvent>((event) {
        state = state.copyWith(isStreamEnded: true);
      });

      await room.connect(
        liveKitUrl,
        token,
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );

      state = state.copyWith(room: room);

      // 3. Publish tracks once connected (only for host)
      if (isHost && track != null) {
        await room.localParticipant?.publishVideoTrack(track);
        await room.localParticipant?.setMicrophoneEnabled(state.isMicOn);
      }

      state = state.copyWith(isConnecting: false);
    } catch (e) {
      debugPrint("Error initializing live stream: $e");
      state = state.copyWith(isConnecting: false, error: e.toString());
    }
  }

  Future<void> sendComment(String text) async {
    if (state.room == null) return;
    final currentUser = state.room!.localParticipant;
    if (currentUser == null) return;

    final messageData = {
      'type': 'chat',
      'senderName': state.isHost ? 'Host' : (currentUser.name ?? 'Guest'),
      'text': text,
      'isHost': state.isHost,
    };

    try {
      await currentUser.publishData(utf8.encode(jsonEncode(messageData)));

      // Add own message to local state
      final newMessage = LiveMessage(
        senderName: state.isHost ? 'Host' : (currentUser.name ?? 'Guest'),
        text: text,
        isHost: state.isHost,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(messages: [...state.messages, newMessage]);
    } catch (e) {
      debugPrint("Error sending chat: $e");
    }
  }

  Future<void> sendLike() async {
    if (state.room == null) return;
    final currentUser = state.room!.localParticipant;
    if (currentUser == null) return;

    final likeData = {'type': 'like'};
    try {
      await currentUser.publishData(utf8.encode(jsonEncode(likeData)));
    } catch (e) {
      debugPrint("Error sending like: $e");
    }
    state = state.copyWith(likeEventCount: state.likeEventCount + 1);
  }

  void toggleCamera() async {
    final newState = !state.isCameraOn;
    state = state.copyWith(isCameraOn: newState);

    if (newState) {
      await state.localVideoTrack?.unmute();
    } else {
      await state.localVideoTrack?.mute();
    }
  }

  void toggleMic() async {
    final newState = !state.isMicOn;
    state = state.copyWith(isMicOn: newState);
    await state.room?.localParticipant?.setMicrophoneEnabled(newState);
  }

  Future<void> stopStream(
    int streamId, {
    required VoidCallback onStopped,
  }) async {
    try {
      // 1. Call backend to stop stream
      await _ref.read(stopStreamProvider.notifier).stopStreamData(streamId);

      // 1.5 Broadcast stream ended to all viewers via LiveKit
      if (state.room != null && state.room!.localParticipant != null) {
        final endData = {'type': 'stream_ended'};
        try {
          await state.room!.localParticipant!.publishData(utf8.encode(jsonEncode(endData)));
        } catch (e) {
          debugPrint("Error broadcasting stream end: $e");
        }
      }

      // 2. Disconnect and cleanup
      await disconnect();

      // 3. Callback to pop UI
      onStopped();
    } catch (e) {
      debugPrint("Error stopping stream: $e");
      // Still disconnect and pop even if backend call fails to ensure vendor can exit
      await disconnect();
      onStopped();
    }
  }

  Future<void> disconnect() async {
    await state.localVideoTrack?.dispose();
    await state.room?.disconnect();
    state = VendorLiveState(); // Reset state
  }

  @override
  void dispose() {
    // Ensure cleanup happens when provider is disposed
    state.localVideoTrack?.dispose();
    state.room?.disconnect();
    super.dispose();
  }
}
