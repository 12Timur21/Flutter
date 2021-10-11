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
  List<Chef> _chefs = [];

  void addChef(Chef chef) {
    _chefs.add(chef);
  }

  void accept(Visitor visitor) {
    _chefs.forEach((chef) {
      chef.accept(visitor);
    });
  }
}

abstract class Chef {
  void accept(Visitor visitor);
}

class ChefTimur implements Chef {
  void accept(Visitor visitor) {
    visitor.tasteTimurDish(this);
  }

  void serveFish() {
    print('Timur подал рыбу');
  }
}

class ChefLeo implements Chef {
  void accept(Visitor visitor) {
    visitor.tasteLeoDish(this);
  }

  void serveChicken() {
    print('Leo подал рыбу');
  }
}

class ChefMax implements Chef {
  void accept(Visitor visitor) {
    visitor.testeMaxDish(this);
  }

  void serveCake() {
    print('Max подал торт');
  }
}

void main() {
  Restauran restauran = Restauran();
  restauran.addChef(ChefTimur());
  restauran.addChef(ChefLeo());
  restauran.addChef(ChefMax());

  restauran.accept(GordonRamsey());
}
