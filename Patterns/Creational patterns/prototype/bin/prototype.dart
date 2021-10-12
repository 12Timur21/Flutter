class Human {
  late String _genes;
  late String _name;
  late int _age;

  set genes(String value) => _genes = value;

  set name(String value) => _name = value;
  String get name => _name;

  set age(int value) => _age = value;
  int get age => _age;

  Human(age, genes, name) {
    _genes = genes;
    _name = name;
    _age = age;
  }

  Human._clone(Human source) {
    _genes = source._genes;
    _name = source._name;
    _age = source._age;
  }

  Human clone() {
    return Human._clone(this);
  }

  @override
  String toString() {
    return '''Name: $_name, 
              Age: $_age, 
              Genetic algorithm: $_genes ''';
  }
}

void main() {
  Human father = Human(20, '01001001110...', 'Stas');
  Human son = father.clone();
  son.name = 'Max';
  son.age = 0;

  Human son2 = father.clone();
  son2.name = 'Timur';
  son2.age = 0;

  print(father.toString());
  print(son.toString());
  print(son2.toString());
  print(father.toString());
}
