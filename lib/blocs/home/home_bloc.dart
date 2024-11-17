import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/parking_spot_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ParkingSpotRepository repository;

  HomeScreenBloc(this.repository) : super(HomeScreenInitial()) {
    on<LoadParkingSpotsEvent>((event, emit) async {
      emit(HomeScreenLoading());
      try {
        final spots = await repository.getAllParkingSpots();
        final spotsRecentlyOrder = await repository.getAllParkingSpots();

        emit(HomeScreenLoaded(spots,spotsRecentlyOrder,[]));
      } catch (e) {
        emit(HomeScreenError("Failed to load parking spots"));
      }
    });

    on<SearchParkingSpotsEvent>((event, emit) async {
      emit(HomeScreenLoading());
      try {
        final spotsBySearch = await repository.getAllParkingSpotsBySearch(event.query);
        emit(HomeScreenLoaded([],[], spotsBySearch));
      } catch (e) {
        emit(HomeScreenError("Search failed"));
      }
    });
  }
}
