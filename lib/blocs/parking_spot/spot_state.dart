// ignore_for_file: non_constant_identifier_names

abstract class ParkingSpotState {}

class ParkingSpotInitial extends ParkingSpotState {}

class ParkingSpotLoading extends ParkingSpotState {}

class ParkingSpotLoaded extends ParkingSpotState {
  final String CurrentImage;
  ParkingSpotLoaded(this.CurrentImage);
}

class ParkingSpotError extends ParkingSpotState {
  final String message;

  ParkingSpotError(this.message);
}