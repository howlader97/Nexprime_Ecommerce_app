import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';

class StreamingSetupState {
  final String title;
  final String offer;
  final File? selectedImage;
  final bool isOfferEnabled;

  StreamingSetupState({this.title = '', this.offer = '', this.selectedImage, this.isOfferEnabled = false});

  StreamingSetupState copyWith({String? title, String? offer, File? selectedImage, bool? isOfferEnabled, bool clearImage = false}) {
    return StreamingSetupState(
      title: title ?? this.title,
      offer: offer ?? this.offer,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isOfferEnabled: isOfferEnabled ?? this.isOfferEnabled,
    );
  }
}

class StreamingSetupNotifier extends StateNotifier<StreamingSetupState> {
  StreamingSetupNotifier() : super(StreamingSetupState());

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateOffer(String offer) {
    state = state.copyWith(offer: offer);
  }

  void updateImage(File? image) {
    state = state.copyWith(selectedImage: image);
  }

  void toggleOffer(bool value) {
    state = state.copyWith(isOfferEnabled: value);
  }

  void reset() {
    state = StreamingSetupState();
  }
}

final streamingSetupProvider = StateNotifierProvider<StreamingSetupNotifier, StreamingSetupState>((ref) {
  return StreamingSetupNotifier();
});
