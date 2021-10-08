class Water {
  double temperature;
  double saltLevel;
  double ironLevel;

  Water(this.temperature, this.saltLevel, this.ironLevel);
}

abstract class WaterStandard {
  WaterStandard? _next;

  WaterStandard addLink(WaterStandard nextLink) {
    return _next = nextLink;
  }

  bool checkStandard(Water water);

  bool checkNext(Water water) {
    if (_next == null) {
      return true;
    }
    return _next!.checkStandard(water);
  }
}

class TemperatureStandard extends WaterStandard {
  static double optimalDrinkingTemperature = 15;

  @override
  bool checkStandard(Water water) {
    if (water.temperature > optimalDrinkingTemperature) {
      print('Вода не оптимально гаряча для полноценного питья');
      return false;
    }
    return checkNext(water);
  }
}

class IronStandard extends WaterStandard {
  static double optimalAmoutIron = 0.2;

  @override
  bool checkStandard(Water water) {
    if (water.ironLevel > optimalAmoutIron) {
      print('В воде слишком много железа');
      return false;
    }
    return checkNext(water);
  }
}

class SaltStandard extends WaterStandard {
  static double optimalAmoutSalt = 1000;

  @override
  bool checkStandard(Water water) {
    if (water.saltLevel > optimalAmoutSalt) {
      print('В воде слишком много соли');
      return false;
    }
    return checkNext(water);
  }
}

void main() {
  Water water = Water(10, 500, 0.2);

  WaterStandard waterStandard = TemperatureStandard();
  waterStandard.addLink(SaltStandard()).addLink(IronStandard());

  if (waterStandard.checkStandard(water)) {
    print('Воду можно пить');
  } else {
    print('Воду пить нелья!');
  }
}
