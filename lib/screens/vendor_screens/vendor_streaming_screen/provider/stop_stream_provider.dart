import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/stream_repository.dart';
import 'package:nexprime/utils/app_log.dart';
final stopStreamProvider =
StateNotifierProvider<StopStreamProvider, bool>((ref) {
  return StopStreamProvider();
});

class StopStreamProvider extends StateNotifier<bool> {
  StopStreamProvider() : super(false);

  Future<bool> stopStreamData(int streamId) async {
    try {
      state = true;

      final response = await StreamingRepository.instance
          .closeStream(streamId: streamId);

      state = false;

      return response;
    } catch (e) {
      state = false;
      errorLog("streaming error", e);
      return false;
    }
  }
}