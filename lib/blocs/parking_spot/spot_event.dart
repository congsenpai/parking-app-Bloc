abstract class ParkingSpotEvent {}

class ChangeImageEvent extends ParkingSpotEvent {
  final String CurrentImage;
  ChangeImageEvent(this.CurrentImage);

}
class FavoriteStateEvent extends ParkingSpotEvent{
  final bool favorite;
  FavoriteStateEvent(this.favorite);
}
