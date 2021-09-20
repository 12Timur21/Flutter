abstract class HeroClass {
  String? _className;
  String? _weapon;

  void activateSkill();
  void actiavatePassiveSkill();
}

class Warrior implements HeroClass {
  Warrior({weapon}) : _weapon = weapon;

  @override
  String? _className = 'Warrior';

  @override
  String? _weapon = '';

  @override
  void activateSkill() {
    if (_weapon == null) {
      print('You hit with your hand');
    } else {
      print('You attacked with a $_weapon');
    }
  }

  @override
  void actiavatePassiveSkill() {
    print('Your defense increased');
  }
}

class Wizzard implements HeroClass {
  Wizzard({weapon}) : _weapon = weapon;

  @override
  String? _className = 'Wizzard';

  @override
  String? _weapon;

  @override
  void activateSkill() {
    if (_weapon == null) {
      print('You cast a spell out of had');
    } else {
      print('You cast a spell from the $_weapon');
    }
  }

  @override
  void actiavatePassiveSkill() {
    print('Your magic skill increased');
  }
}

enum HeroClassList { warrior, wizzard }

abstract class HeroFactory {
  static HeroClass selectHeroClass(HeroClassList heroClassList) {
    if (HeroClassList.warrior == heroClassList) {
      return new Warrior();
    } else if (HeroClassList.wizzard == heroClassList) {
      return new Wizzard();
    } else {
      throw Exception('Hero class is not defined!');
    }
  }
}

void main() {
  HeroClass selectedHeroClass =
      HeroFactory.selectHeroClass(HeroClassList.warrior);
  selectedHeroClass.activateSkill();
}
