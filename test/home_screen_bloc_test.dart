import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:project_smart_parking_app/blocs/home/home_bloc.dart';
import 'package:project_smart_parking_app/blocs/home/home_event.dart';
import 'package:project_smart_parking_app/blocs/home/home_state.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';


// Mock classes
class MockParkingSpotRepository extends Mock implements ParkingSpotRepository {}

void main() {
  group('HomeScreenBloc', () {
    late HomeScreenBloc bloc;
    late MockParkingSpotRepository repository;

    // Dummy data
    final mockParkingSpots = [
      ParkingSpotModel(
          spotId: 'spotID1',
          costPerHourCar: 10,
          costPerHourMoto: 10,
          spotName: '',
          listImage: [],
          location: GeoPoint(0, 0),
          OccupiedMaxCar: 10, OccupiedMaxMotor: 10, star: null, describe: '', reviewsNumber: null),
      ParkingSpotModel(
          spotId: 'spotID2',
          costPerHourCar: 10,
          costPerHourMoto: 10,
          spotName: '',
          listImage: [],
          location: GeoPoint(0, 0),
          OccupiedMaxCar: 10, OccupiedMaxMotor: 10, star: null, describe: '', reviewsNumber: null),
    ];

    setUp(() {
      repository = MockParkingSpotRepository();
      bloc = HomeScreenBloc(repository);
    });

    tearDown(() {
      bloc.close();
    });

    // Test case 1: Initial state
    test('initial state is HomeScreenInitial', () {
      () => [
        isA<HomeScreenInitial>()
      ];
    });

    // Test case 2: LoadParkingSpotsEvent success
    blocTest<HomeScreenBloc, HomeScreenState>(
      'emits [HomeScreenLoading, HomeScreenLoaded] when LoadParkingSpotsEvent is added and repository succeeds',
      build: () {
        when(() => repository.getAllParkingSpots())
            .thenAnswer((_) async => mockParkingSpots);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadParkingSpotsEvent('')),

       expect: () => [
          isA<HomeScreenLoaded>()
        ]
    );

    // Test case 3: LoadParkingSpotsEvent failure
    blocTest<HomeScreenBloc, HomeScreenState>(
      'emits [HomeScreenLoading, HomeScreenError] when LoadParkingSpotsEvent is added and repository fails',
      build: () {
        when(() => repository.getAllParkingSpots())
            .thenThrow(Exception('Error loading spots'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadParkingSpotsEvent('')),
      expect: () => [
          isA<HomeScreenError>()

      ],
    );

    // Test case 4: SearchParkingSpotsEvent success
    blocTest<HomeScreenBloc, HomeScreenState>(
      'emits [HomeScreenLoading, HomeScreenLoaded] when SearchParkingSpotsEvent is added and repository succeeds',
      build: () {
        when(() => repository.getAllParkingSpots())
            .thenAnswer((_) async => mockParkingSpots);
        when(() => repository.getAllParkingSpotsBySearchSpotName('query'))
            .thenAnswer((_) async => [mockParkingSpots.first]);
        return bloc;
      },
      act: (bloc) => bloc.add(SearchParkingSpotsEvent('query','')),
      expect: () => [
        isA<HomeScreenLoaded>()

      ],

    );

    // Test case 5: SearchParkingSpotsEvent failure
    blocTest<HomeScreenBloc, HomeScreenState>(
      'emits [HomeScreenLoading, HomeScreenError] when SearchParkingSpotsEvent is added and repository fails',
      build: () {
        when(() => repository.getAllParkingSpots())
            .thenAnswer((_) async => mockParkingSpots);
        when(() => repository.getAllParkingSpotsBySearchSpotName('query'))
            .thenThrow(Exception('Error searching spots'));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchParkingSpotsEvent('query','')),
      expect: () => [
        isA<HomeScreenError>()
      ],
    );
  });
}
