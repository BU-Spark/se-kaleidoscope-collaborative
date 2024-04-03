// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  // final Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController _mapController;
  late Map<MarkerId, Marker> _markers;
  late LatLng _currentPosition;
  late LatLng _destination;

  @override
  void initState() {
    super.initState();
    _markers = <MarkerId, Marker>{};
    _currentPosition = LatLng(37.33500926, -122.03272188);
    _destination = LatLng(37.33429383, -122.06600055);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _addMarker(_currentPosition, "Current Location");
    _addMarker(_destination, "Destination");
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
      ),
    );
  }

  void _addMarker(LatLng location, String title) {
    final MarkerId markerId = MarkerId(title);
    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: title, snippet: ''),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.33500926, -122.03272188),
          zoom: 15,
        ),
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}