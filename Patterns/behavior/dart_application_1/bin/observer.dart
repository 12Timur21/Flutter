abstract class Observer {
  void update(String state);
}

class Subscriber extends Observer {
  String subscriberName;
  late String observerState;
  Newspaper subscription;

  Subscriber(this.subscription, this.subscriberName);

  void update(String state) {
    print('Подписчик $subscriberName получил $state');
    observerState = state;
  }
}

abstract class News {
  List<Observer> _observers = [];
  late String _state;

  void attach(Observer observer) {
    _observers.add(observer);
  }

  void detach(Observer observer) {
    _observers.remove(observer);
  }

  void notify() {
    _observers.forEach((observer) {
      observer.update(_state);
    });
  }
}

class Newspaper extends News {
  String _state = '';

  String get state => _state;
  set state(String state) => _state = state;
}

void main() {
  Newspaper newspaper = Newspaper();

  newspaper.attach(Subscriber(newspaper, 'Timur'));
  newspaper.attach(Subscriber(newspaper, 'Max'));

  newspaper.state = 'Newspaper 10/09/2021';
  newspaper.notify();
}
