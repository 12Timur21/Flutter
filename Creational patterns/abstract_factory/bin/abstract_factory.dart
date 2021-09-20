import 'package:abstract_factory/abstract_factory.dart' as abstract_factory;

abstract class Race {
  String? raceName;

  void activatePassiveRaceSkill(ClassHero classHero);
}

class Human implements Race {
  @override
  String? raceName = 'Human';

  @override
  void activatePassiveRaceSkill(ClassHero classHero) {
    classHero.damage += 10;
    print('Attack increased at 10 points.');
  }
}

class Elf implements Race {
  @override
  String? raceName = 'Elf';

  @override
  void activatePassiveRaceSkill(ClassHero classHero) {
    classHero.damage += 20;
    print('Attack increased at 20 points.');
  }
}

abstract class ClassHero {
  String className = '';
  int damage = 0;

  void attackTarget(String target);
}

class Warrior implements ClassHero {
  String className = "Warrior";
  int damage = 80;

  @override
  void attackTarget(String target) {
    print("$damage damage to $target");
  }
}

class Wizzard implements ClassHero {
  String className = "Wizzard";
  int damage = 200;

  @override
  void attackTarget(String target) {
    print("$damage damage to $target");
  }
}

abstract class PersonageFactory {
  Race selectRace();
  ClassHero selectHeroClass();
}

class HumanWarrior implements PersonageFactory {
  @override
  Race selectRace() {
    return new Human();
  }

  @override
  ClassHero selectHeroClass() {
    return new Warrior();
  }
}

class ElfWizzard implements PersonageFactory {
  @override
  Race selectRace() {
    return new Elf();
  }

  @override
  ClassHero selectHeroClass() {
    return new Wizzard();
  }
}

class Application {
  late Race race;
  late ClassHero classHero;

  Application(PersonageFactory personageFactory) {
    race = personageFactory.selectRace();
    classHero = personageFactory.selectHeroClass();
  }

  void startGame() {
    classHero.attackTarget("chicken");
    race.activatePassiveRaceSkill(classHero);
    classHero.attackTarget("chicken");
  }
}

void main() {
  Application application = new Application(ElfWizzard());
  application.startGame();
}
