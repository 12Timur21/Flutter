import 'bottomSheet_state.dart';

class BottomSheet {}

class OpenRecoderPage extends BottomSheet {
  OpenRecoderPage();
}

class OpenListeningPage extends BottomSheet {
  OpenListeningPage();
}

class OpenPreviewPage extends BottomSheet {
  String soundTitle;
  OpenPreviewPage(this.soundTitle);
}
