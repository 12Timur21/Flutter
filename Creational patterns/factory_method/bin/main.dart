abstract class HeroClass {
  late String _className;
  String? _weapon;

  void activateSkill();
  void actiavatePassiveSkill();
}

class Warrior implements HeroClass {
  Warrior([this._weapon]);

  String _className = 'Warrior';
  String? _weapon;

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
  Wizzard([this._weapon]);

  @override
  String _className = 'Wizzard';

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
      return Warrior('broken sword');
    } else if (HeroClassList.wizzard == heroClassList) {
      return Wizzard();
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
