import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexprime/services/repository/stream_repository.dart';
import 'package:nexprime/utils/app_log.dart';

import '../../../../models/stream_notification_model.dart';

final streamNotificationProvider=StateNotifierProvider<StreamNotificationProvider,AsyncValue<List<StreamNotificationModel>>>((ref){
  return StreamNotificationProvider();
});

class  StreamNotificationProvider extends StateNotifier<AsyncValue<List<StreamNotificationModel>>>{
  StreamNotificationProvider():super(AsyncData([]),){getNotification();}

  Future<void>  getNotification()async{
    state=AsyncLoading();
    try{
      final response= await StreamingRepository.instance.fetchNotification();
      state=AsyncData(response);
    }catch(e,st){
      errorLog("stream notification", e);
      state = AsyncError(e, st);
    }
  }
}