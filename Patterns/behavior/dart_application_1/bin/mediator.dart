import 'dart:async';
import 'dart:math';

class Company {
  Mediator mediator;

  Company(this.mediator);
}

class Producer extends Company {
  Producer(Mediator mediator) : super(mediator);

  List<String> _producedGoods = [
    'juices',
    'salads',
    'drinks',
    'vegetables',
    'fruits'
  ];

  void produceGoods() {
    int randomGoodsIndex = Random().nextInt(_producedGoods.length);

    print('Произведено: ${_producedGoods[randomGoodsIndex]}');

    mediator.send(_producedGoods[randomGoodsIndex], this);
  }
}

class Shop extends Company {
  Shop(Mediator mediator) : super(mediator);

  void putProductOnShelf(String product) {
    print('Товар $product был выставлен на полки');
    Timer(Duration(seconds: 3), () {
      print('Товар $product просрочен и отправлен на утилизацию');
      mediator.send(product, this);
    });
  }
}

class GarbageCollector extends Company {
  GarbageCollector(Mediator mediator) : super(mediator);

  void takeOutTrash(String product) {
    print('Товар $product был отправлен на утилизацию');
  }
}

abstract class Mediator {
  void send(String item, Company company);
}

class Storage implements Mediator {
  Producer? _producer;
  Shop? _shop;
  GarbageCollector? _garbageCollector;

  set producer(Producer producer) => _producer = producer;
  set shop(Shop shop) => _shop = shop;
  set garbageCollector(GarbageCollector garbageCollector) =>
      _garbageCollector = garbageCollector;

  void send(String goods, Company company) {
    if (company == _producer) {
      _shop?.putProductOnShelf(goods);
    } else if (company == _shop) {
      _garbageCollector?.takeOutTrash(goods);
    } else {
      print('Компания не закреплена за складом');
    }
  }
}

void main() {
  Storage storage = Storage();

  Producer producer = Producer(storage);
  Shop shop = Shop(storage);
  GarbageCollector garbageCollector = GarbageCollector(storage);

  storage.producer = producer;
  storage.shop = shop;
  storage.garbageCollector = garbageCollector;

  producer.produceGoods();
}
