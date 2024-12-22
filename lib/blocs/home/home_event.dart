abstract class HomeScreenEvent {}

class LoadParkingSpotsEvent extends HomeScreenEvent {
  final String userId;
  LoadParkingSpotsEvent(this.userId);
}

class SearchParkingSpotsEvent extends HomeScreenEvent {
  final String query;
  final String userId;
  SearchParkingSpotsEvent(this.query, this.userId);
}