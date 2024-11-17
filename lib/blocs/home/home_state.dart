import '../../models/parking_spot_model.dart';

abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<ParkingSpotModel> parkingSpotsRecentlyOrder;
  final List<ParkingSpotModel> parkingSpots;
  final List<ParkingSpotModel> parkingSpotsBySearch;

  HomeScreenLoaded(this.parkingSpots, this.parkingSpotsBySearch, this.parkingSpotsRecentlyOrder);
}

class HomeScreenError extends HomeScreenState {
  final String message;

  HomeScreenError(this.message);
}
