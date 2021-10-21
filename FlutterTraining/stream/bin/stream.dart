import 'dart:async';

import 'dart:math';

void main() {
  // Stream<int> stream = Stream.periodic(Duration(seconds: 1), (tick) => tick);

  // StreamSubscription<int> subscription;

  // subscription = stream.listen((event) {
  //   print(event);
  // });

  // Future.delayed(Duration(seconds: 3), () {
  //   subscription.cancel();
  // });

  //*

  // Future.delayed(Duration(seconds: 3), () {
  //   subscription.pause();
  // });

  // Future.delayed(Duration(seconds: 6), () {
  //   subscription.resume();
  // });

  //*

  // Stream<int> stream2 =
  //     Stream.periodic(Duration(seconds: 1), (_) => Random().nextInt(10))
  //         .asBroadcastStream();
  // StreamSubscription<int> subscription2, subscription3;

  // subscription2 = stream2.listen((event) {
  //   print(event);
  // });
  // subscription3 = stream2.listen((event) {
  //   print(event);
  // });

  //*

  StreamController<int> controller = StreamController<int>();

  StreamSubscription<int>? subscriptionOne;

  controller.add(1);
  controller.add(2);

  subscriptionOne = controller.stream.listen((event) {
    print(event);
  });

  controller.add(3);
  controller.add(4);

  Future.delayed(Duration(seconds: 5),
      () => {subscriptionOne?.cancel(), controller.close()});

  //*
}
