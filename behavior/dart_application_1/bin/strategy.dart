abstract class Strategy {
  void execute();
}

class AttackStrategy implements Strategy {
  @override
  void execute() {
    print('Вы решительно наступаете на врагов');
  }
}

class DefenceStrategy implements Strategy {
  @override
  void execute() {
    print('Вы заняли оборонительные позиции');
  }
}

class WithdrawalStrategy implements Strategy {
  @override
  void execute() {
    print('Вы приняли решение убежать');
  }
}

class Context {
  Strategy _strategy;

  Context(this._strategy);

  set strategy(Strategy strategy) => _strategy = strategy;

  void executeStrategy() {
    _strategy.execute();
  }
}

void main() {
  Context context = Context(AttackStrategy());
  context.executeStrategy();

  context.strategy = DefenceStrategy();
  context.executeStrategy();
}
