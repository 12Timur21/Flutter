class Item {
  late String itemName;

  Item(this.itemName);

  void use() {
    print('Вы использовали $itemName');
  }
}

class ItemsFactory {
  static Map<String, Item> _items = {'table': Item('table')};

  ItemsFactory();

  Item getItem(String itemName) {
    return _items.putIfAbsent(itemName, () => Item(itemName));
  }

  void printItems() {
    _items.forEach((_, value) {
      value.use();
    });
  }
}

void main() {
  ItemsFactory itemFactory = ItemsFactory();

  Item item1 = itemFactory.getItem('chair');
  Item item2 = itemFactory.getItem('wall');
  Item item3 = itemFactory.getItem('wall');
  Item item4 = itemFactory.getItem('board');

  if (item2 == item3) {
    print('Objects are indectical');
  } else {
    print('Objects are not indectical');
  }

  itemFactory.printItems();
}
