abstract class HomeScreenEvent {}

class LoadParkingSpotsEvent extends HomeScreenEvent {}

class SearchParkingSpotsEvent extends HomeScreenEvent {
  final String query;

  SearchParkingSpotsEvent(this.query);
}