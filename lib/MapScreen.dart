import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Marker? _marker;
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Location Tracker")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 16,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _marker != null ? {_marker!} : {},
        polylines: {
          Polyline(
            polylineId: PolylineId("tracking"),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _updateLocation();
  }

  Future<void> _updateLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );

    LatLng newPosition = LatLng(position.latitude, position.longitude);
    //print('My new position: $newPosition');
    setState(() {
      _currentPosition = newPosition;
      _marker = Marker(
        markerId: MarkerId("current_location"),
        position: _currentPosition!,
        infoWindow: InfoWindow(
          title: "My Current Location",
          snippet: "Lat: ${position.latitude}, Lng: ${position.longitude}",
        ),
      );
      _polylineCoordinates.add(newPosition);
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

}
