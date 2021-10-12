//Лампочка
abstract class Bulb {
  late String _backlightColor;
  late int _maxBrightnessLevel;
  late bool isActive;
  late int _brightnessLevel;

  void turnOn();
  void turnOff();
  void setBrighnessLevel(int level);
}

class GreenBulb implements Bulb {
  String _backlightColor = 'зелёным';
  int _maxBrightnessLevel = 10;

  bool isActive = false;
  int _brightnessLevel = 5;

  void turnOn() {
    isActive = true;
  }

  void turnOff() {
    isActive = false;
  }

  void setBrighnessLevel(int level) {
    if (level > _maxBrightnessLevel) {
      _brightnessLevel = _maxBrightnessLevel;
    } else {
      _brightnessLevel = level;
    }
  }
}

class YellowBulb implements Bulb {
  String _backlightColor = 'жёлтым';
  int _maxBrightnessLevel = 20;

  bool isActive = false;
  int _brightnessLevel = 5;

  void turnOn() {
    print('Включена лампа з $_backlightColor цветом');
    isActive = true;
  }

  void turnOff() {
    print('Лампа выключена');
    isActive = false;
  }

  void setBrighnessLevel(int level) {
    if (level > _maxBrightnessLevel) {
      _brightnessLevel = _maxBrightnessLevel;
    } else {
      _brightnessLevel = level;
    }

    print('Яркость лампы выставлена на $_brightnessLevel');
  }
}

class Lamp {
  Bulb _bulb;
  Lamp(this._bulb);

  void tooglePower() {
    _bulb.isActive ? _bulb.turnOff() : _bulb.turnOn();
  }

  void setBrighnessLevel(int level) {
    _bulb.setBrighnessLevel(level);
  }
}

void main() {
  Lamp lamp = Lamp(YellowBulb());
  lamp.tooglePower();
  lamp.setBrighnessLevel(15);
  lamp.tooglePower();
}
