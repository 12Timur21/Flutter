class Bulb {
  void turnOn() {
    print('Лампочка включена');
  }

  void turnOff() {
    print('Лампочка выключена');
  }

  void changeColor() {}

  void changeBrightness() {}

  void checkBulb() {
    turnOn();
    changeColor();
    changeBrightness();
    turnOff();
  }
}

class RGBBulb extends Bulb {
  @override
  void changeColor() {
    print('Цвет лампочки сменился на другой');
  }
}

class DefaultBulb extends Bulb {
  @override
  void changeBrightness() {
    print('Яркость лампочки сменилась');
  }
}

void main() {
  RGBBulb().checkBulb();

  print('-----------------');

  DefaultBulb().checkBulb();
}
