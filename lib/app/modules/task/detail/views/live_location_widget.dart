import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LiveLocationMapWidget extends StatefulWidget {
  final void Function(Position position) onLocationChanged;

  const LiveLocationMapWidget({super.key, required this.onLocationChanged});

  @override
  State<LiveLocationMapWidget> createState() => _LiveLocationMapWidgetState();
}

class _LiveLocationMapWidgetState extends State<LiveLocationMapWidget> {
  Position? _currentPosition;
  late final Stream<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    _positionStream.listen((position) {
      setState(() => _currentPosition = position);
      widget.onLocationChanged(position); // 👈 Pass location to parent
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final latLng = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    return AspectRatio(
      aspectRatio: 2 / 1,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: latLng, zoom: 16),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {Marker(markerId: const MarkerId('user'), position: latLng)},
      ),
    );
  }
}
