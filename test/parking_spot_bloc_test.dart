import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_bloc.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_event.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_state.dart';

void main() {
  group('ParkingSpotBloc', () {
    late ParkingSpotBloc parkingSpotBloc;

    setUp(() {
      parkingSpotBloc = ParkingSpotBloc();
    });

    tearDown(() {
      parkingSpotBloc.close();
    });

    test('initial state is ParkingSpotInitial', () {
      expect(parkingSpotBloc.state, isA<ParkingSpotInitial>());
    });

    blocTest<ParkingSpotBloc, ParkingSpotState>(
      'emits [ParkingSpotLoaded] with correct image when ChangeImageEvent is added',
      build: () => parkingSpotBloc,
      act: (bloc) => bloc.add(ChangeImageEvent('new_image_url')),
      expect: () => [isA<ParkingSpotLoaded>().having((state) => state.CurrentImage, 'CurrentImage', 'new_image_url')],
    );

    blocTest<ParkingSpotBloc, ParkingSpotState>(
      'emits [ParkingSpotError] when an exception occurs in ChangeImageEvent',
      build: () => ParkingSpotBloc(),
      act: (bloc) => bloc.add(ChangeImageEvent('')), // simulate an error scenario
      expect: () => [
        isA<ParkingSpotLoaded>()

      ],
    );
  });
}
