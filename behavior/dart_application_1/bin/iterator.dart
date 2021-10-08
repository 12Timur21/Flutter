class ReverseIterator implements Iterator {
  List _list = [];
  String? _current;
  int index;

  ReverseIterator(this._list) : index = _list.length;

  bool moveNext() {
    if (index <= 0) {
      return false;
    } else {
      index--;
      _current = _list[index];
      return true;
    }
  }

  String? get current => _current;
}

void main() {
  List<String> names = ['Timur', 'Maxim', 'Stas', 'Vlad'];

  ReverseIterator reverseIterator = ReverseIterator(names);

  while (reverseIterator.moveNext()) {
    print('Fruit name: ${reverseIterator.current}');
  }
}
