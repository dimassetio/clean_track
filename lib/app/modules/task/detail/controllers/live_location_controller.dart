import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveLocationController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  Stream<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    positionStream!.listen((Position position) {
      currentPosition.value = position;
      // _saveLocationToFirestore(position);
    });
  }

  // void _saveLocationToFirestore(Position position) {
  //   FirebaseFirestore.instance.collection('user_locations').add({
  //     'latitude': position.latitude,
  //     'longitude': position.longitude,
  //     'timestamp': FieldValue.serverTimestamp(),
  //     // Optionally add user ID if using Firebase Auth
  //   });
  // }
}
