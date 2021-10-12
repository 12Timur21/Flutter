void main() {
  USBCharger usbCharger = USBCharger();
  TypeC_Adapter typeCAdapter = TypeC_Adapter(usbCharger);

  Notebook notebook = Notebook(typeCAdapter);
}

class USBCharger {
  void turnOnPower() {
    print('USB зарядное включено');
  }

  void turnOffPower() {
    print('USB зарядное отлючёно');
  }
}

class TypeC_Charger {
  void turnOnPower() {
    print('TypeC зарядное включено');
  }

  void turnOffPower() {
    print('TypeC зарядное отлючёно');
  }
}

class TypeC_Adapter extends TypeC_Charger {
  USBCharger usbCharger;

  TypeC_Adapter(this.usbCharger);

  @override
  void turnOnPower() {
    print('USB зарядное включено и работает через адаптер TypeC');
  }

  @override
  void turnOffPower() {
    print('TypeC адаптер выключён');
  }
}

class Notebook {
  late TypeC_Charger _powerConnector;

  Notebook(TypeC_Charger charger) {
    _powerConnector = charger;
    _powerConnector.turnOnPower();
  }
}
