class Picture {
  String _picture;

  Picture(this._picture);

  String get picture {
    return _picture;
  }
}

class Painter {
  String _picture;

  Painter(this._picture);

  String get picture => _picture;
  void set picture(String state) {
    _picture = state;
  }

  Picture saveChanges() {
    return Picture(_picture);
  }

  void restoreChanges(Picture picture) {
    _picture = picture.picture;
  }
}

class PictureStorage {
  Picture _picture;

  PictureStorage(this._picture);

  Picture get picture => _picture;
  void set picture(Picture picture) {
    _picture = picture;
  }
}

void main() {
  Painter painter = Painter("Draw circle");
  painter.picture += ",add red rectangle";

  print(painter._picture);

  Picture pictureBackup = painter.saveChanges();
  PictureStorage pictureStorage = PictureStorage(pictureBackup);

  painter.picture += ", add ugly square";
  print(painter._picture);

  painter.restoreChanges(pictureStorage.picture);

  print(painter._picture);
}
