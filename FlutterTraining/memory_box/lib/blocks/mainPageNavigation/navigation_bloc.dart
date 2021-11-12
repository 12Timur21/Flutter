import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/screens/homePage.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(NavigationState initialState) : super(initialState);
  //! Какой-то initialState лишний

  // @override
  // NavigationState get initialState =>
  //     NavigationState(NavigationItem[HomePage.routeName]);
  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is NavigateTo) {
      if (event.destination != state.selectedItem) {
        yield NavigationState(
          selectedItem: NavigationItem[event.destination],
        );
      }
    }
  }
}
