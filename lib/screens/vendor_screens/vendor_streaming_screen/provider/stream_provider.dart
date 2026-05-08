import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/stream_repository.dart';

final streamProvider =
    StateNotifierProvider<StreamNotifier, AsyncValue<Map<String, dynamic>?>>((
      ref,
    ) {
      return StreamNotifier();
    });

class StreamNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  StreamNotifier() : super(const AsyncValue.data(null));

  final StreamingRepository _repository = StreamingRepository.instance;

  Future<void> startStream({
    required String thumbnail,
    required String title,
    required String offer,
  }) async {
    state = const AsyncValue.loading();

    try {
      final imageUrl = await _repository.uploadImage(
        imageFile: File(thumbnail),
      );

      if (imageUrl == null) {
        state = const AsyncValue.error("Image upload failed", StackTrace.empty);
        return;
      }

      final response = await _repository.startStreaming(
        thumbnail: imageUrl,
        title: title,
        offer: offer,
      );

      if (response != null) {
        state = AsyncValue.data(response);
      } else {
        state = const AsyncValue.error(
          "Stream creation failed",
          StackTrace.empty,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
