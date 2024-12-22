import 'package:flutter_bloc/flutter_bloc.dart';


import '../../repositories/parking_spot_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ParkingSpotRepository repository;


  HomeScreenBloc(this.repository)
      : super(HomeScreenInitial()) {
    on<LoadParkingSpotsEvent>(_homeScreenStart);
    on<SearchParkingSpotsEvent>(_homeScreenSearch);
  }

  // Định nghĩa lại hàm _homeScreenLoading với đúng cú pháp và kiểu trả về
  Future<void> _homeScreenStart(LoadParkingSpotsEvent event,
      Emitter<HomeScreenState> emit) async {
    // emit(HomeScreenLoading());
    try {
      final spots = await repository.getAllParkingSpots();
      final spotsRecentlyOrder = await repository.getParkingSpotbyRecentlyTransaction(event.userId);
      emit(HomeScreenLoaded(spots,[],spotsRecentlyOrder));
    } catch (e) {
      emit(HomeScreenError("Failed to load parking spots"));
    }
  }

  Future<void> _homeScreenSearch(SearchParkingSpotsEvent event,
      Emitter<HomeScreenState> emit) async {
    // emit(HomeScreenLoading());
    try {
      final spots = await repository.getAllParkingSpots();
      final spotsRecentlyOrder = await repository.getParkingSpotbyRecentlyTransaction(event.userId); // Bạn có thể thay đổi nếu cần
      final spotsBySearch = await repository.getAllParkingSpotsBySearchSpotName(
          event.query);
      emit(HomeScreenLoaded(spots, spotsBySearch,spotsRecentlyOrder));
    }
    catch (e) {
      emit(HomeScreenError('Failed to search parking spots'));
    }
  }

}


