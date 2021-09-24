class Human {
  String? _genes;
  String? _name;
  int? _age;

  set genes(String value) => _genes = value;
  set name(String value) => _name = value;
  set age(int value) => _age = value;

  bool isClone = false;

  Human(age, genes, name) {
    _genes = genes;
    _name = name;
    _age = age;
    isClone = true;
  }
  Human._clone(Human source) {
    _genes = source._genes;
    _name = source._name;
    _age = 0;
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
  son._name = 'Max';

  Human son2 = father.clone();
  son._name = 'Timur';

  print(father.toString());
  print(son.toString());
  print(son2.toString());
  print(father.toString());
}
