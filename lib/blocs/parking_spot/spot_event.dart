// ignore_for_file: non_constant_identifier_names

abstract class ParkingSpotEvent {}

class ChangeImageEvent extends ParkingSpotEvent {
  final String CurrentImage;
  ChangeImageEvent(this.CurrentImage);

}
class FavoriteStateEvent extends ParkingSpotEvent{
  final bool favorite;
  FavoriteStateEvent(this.favorite);
}
