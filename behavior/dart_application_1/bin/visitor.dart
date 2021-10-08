abstract class Visitor {
  void tasteTimurDish(ChefTimur chef);
  void tasteLeoDish(ChefLeo chef);
  void testeMaxDish(ChefMax chef);
}

class GordonRamsey implements Visitor {
  void tasteTimurDish(ChefTimur chef) {
    chef.serveFish();
  }

  void tasteLeoDish(ChefLeo chef) {
    chef.serveChicken();
  }

  void testeMaxDish(ChefMax chef) {
    chef.serveCake();
  }
}

class Restauran {
  List<Chef> chefs = [];

  void Add(Chef element) {
    chefs.add(element);
  }

  void Accept(Visitor visitor) {
    chefs.forEach((element) {
      element.Accept(visitor);
    });
  }
}

abstract class Chef {
  void Accept(Visitor visitor);
}

class ChefTimur implements Chef {
  void Accept(Visitor visitor) {
    visitor.tasteTimurDish(this);
  }

  void serveFish() {
    print('Timur подал рыбу');
  }
}

class ChefLeo implements Chef {
  void Accept(Visitor visitor) {
    visitor.tasteLeoDish(this);
  }

  void serveChicken() {
    print('Leo подал рыбу');
  }
}

class ChefMax implements Chef {
  void Accept(Visitor visitor) {
    visitor.testeMaxDish(this);
  }

  void serveCake() {
    print('Max подал торт');
  }
}

void main() {
  Restauran restauran = Restauran();
  restauran.Add(ChefTimur());
  restauran.Add(ChefLeo());
  restauran.Add(ChefMax());

  restauran.Accept(GordonRamsey());
}
