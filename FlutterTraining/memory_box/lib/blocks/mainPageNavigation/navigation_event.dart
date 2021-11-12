abstract class NavigationEvent {
  const NavigationEvent();
}

class NavigateTo extends NavigationEvent {
  const NavigateTo(this.destination);

  final String destination;
}
