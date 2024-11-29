import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_event.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_state.dart';



class ParkingSpotBloc extends Bloc<ParkingSpotEvent, ParkingSpotState> {



  ParkingSpotBloc()
      : super(ParkingSpotInitial()) {
    on<ChangeImageEvent>(_ChangeImage);
  }
  Future<void> _ChangeImage(ChangeImageEvent event,
      Emitter< ParkingSpotState> emit) async {
    // emit(HomeScreenLoading());
    try {
      final CurrentImage = event.CurrentImage;
      emit(ParkingSpotLoaded(CurrentImage));
    }
    catch (e) {
      emit(ParkingSpotError('Failed to search parking spots'));
    }
  }

}