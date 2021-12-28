class NavigationState {
  final NavigationPages? selectedItem;
  const NavigationState({required this.selectedItem});
}

enum NavigationPages {
  homePage,
  collectionsListPage,
  recordingPage,
  audioListPage,
  profilePage,
  subscriptionPage,
  selectionsPage,
}
