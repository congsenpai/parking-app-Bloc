abstract class ParkingSpotEvent {}

class ChangeImageEvent extends ParkingSpotEvent {
  final String Image;
  ChangeImageEvent(this.Image);
}
class AddFavoriteEvent extends ParkingSpotEvent{
}
