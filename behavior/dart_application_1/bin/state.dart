abstract class State {
  void action(Web web);
}

class BeforeRendering implements State {
  void action(Web web) {
    print('Выполняются действия до рендеринга');

    web._state = DuringRendering();
  }
}

class DuringRendering extends State {
  void action(Web web) {
    print('Выполняются действия во время рендеринга');

    web._state = AfterRendering();
  }
}

class AfterRendering extends State {
  void action(Web web) {
    print('Выполняются действие после рендеринга');

    web._state = BeforeRendering();
  }
}

class Web {
  State _state;

  Web(this._state);

  set state(State state) => _state = state;

  void start() {
    _state.action(this);
  }
}

void main() {
  Web web = Web(BeforeRendering());

  web.start();
  web.start();
  web.start();

  web.start();
}
