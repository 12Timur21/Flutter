// class ReverseIterator<T> implements Iterator<T> {
//   List<T> _list = [];
//   int? _current;
//   int index;

//   ReverseIterator(this._list) : index = _list.length;

//   bool moveNext() {
//     if (index <= 0) {
//       return false;
//     } else {
//       index--;
//       _current = _list[index];
//       return true;
//     }
//   }

//   int? get current => _current;
// }

// void main() {
//   List<int> numbers = [1, 2, 3, 4, 5];

//   ReverseIterator reverseIterator = ReverseIterator(numbers);

//   while (reverseIterator.moveNext()) {
//     print('Current number: ${reverseIterator.current}');
//   }
// }
