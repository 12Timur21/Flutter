abstract class Subject {
  String _name = '';
  void doAction();
}

class Package implements Subject {
  String _name;
  static double totalPackageSum = 0;

  Set<Subject> _childSubject = Set();

  Package(this._name);

  void addChild(Subject child) {
    _childSubject.add(child);
  }

  @override
  void doAction() {
    _childSubject.isEmpty ? print(_name) : print('Внутри $_name лежит:');
    _childSubject.forEach((thing) => thing.doAction());
  }
}

class Procuct implements Subject {
  String _name;
  double _price;
  Procuct(this._name, this._price);

  @override
  void doAction() {
    Package.totalPackageSum += _price;
    print("- $_name");
  }
}

void main() {
  Package basket = Package("корзины");
  Package paperPackage = Package("бумажной упаковки");
  Package plasticPackage = Package("пластикового пакета");

  Procuct product1 = Procuct("Кофе", 20);
  Procuct product2 = Procuct("Оливковое масло", 5);
  Procuct product3 = Procuct("Яблоки", 15);
  Procuct product4 = Procuct("Бананы", 22);

  plasticPackage.addChild(product1);
  plasticPackage.addChild(product2);

  paperPackage.addChild(product3);
  paperPackage.addChild(product4);

  basket.addChild(paperPackage);
  basket.addChild(plasticPackage);

  basket.doAction();

  print('Общая сумма корзины: ${Package.totalPackageSum}');
}
