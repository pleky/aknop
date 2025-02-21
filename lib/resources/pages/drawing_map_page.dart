import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/providers/location_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/drawing_map_controller.dart';

class DrawingMapPage extends NyStatefulWidget<DrawingMapController> {
  static RouteView path = ("/drawing-map", (_) => DrawingMapPage());

  DrawingMapPage({super.key}) : super(child: () => _DrawingMapPageState());
}

class _DrawingMapPageState extends NyState<DrawingMapPage> {
  /// [DrawingMapController] controller
  DrawingMapController get controller => widget.controller;
  LocationProvider locationProvider = LocationProvider();

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late Position initialLocation;
  Set<Polygon> polygons = {};
  List<LatLng> polygonPoints = [];
  Set<Marker> markers = {};
  bool isDrawingPolygon = false;

  @override
  get init => () async {
        final currentLocation = await locationProvider.getCurrentLocation();

        initialLocation = currentLocation;
        polygonPoints.add(LatLng(initialLocation.latitude, initialLocation.longitude));

        markers = {
          Marker(
            markerId: MarkerId('marker_id'),
            position: LatLng(initialLocation.latitude, initialLocation.longitude),
            infoWindow: InfoWindow(title: 'Your Location'),
          )
        };

        markers.add(Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          onTap: () => _onMarkerTapped(
            LatLng(currentLocation.latitude, currentLocation.longitude),
          ),
        ));

        final initialPolygons = widget.data(); // get initial polygons from navigation arguments string
        if (initialPolygons != null && initialPolygons.isNotEmpty) {
          initialPolygons.forEach((List<double> point) {
            polygonPoints.add(LatLng(point[0], point[1]));
            markers.add(Marker(
              markerId: MarkerId('point_${polygonPoints.length}'),
              position: LatLng(point[0], point[1]),
            ));
          });
          _updatePolygon();
        }

        _updatePolygon();
      };

  void _updatePolygon() {
    // Ensure the last point connects to the first point
    final closedPoints = List<LatLng>.from(polygonPoints);
    if (polygonPoints.isNotEmpty) {
      closedPoints.add(polygonPoints.first); // Add the first point to close the polygon
    }

    setState(() {
      polygons = {
        Polygon(
          polygonId: PolygonId('user_drawn_polygon'),
          points: closedPoints,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 2,
        ),
      };
    });
  }

  void _onMapTapped(LatLng point) {
    if (!isDrawingPolygon) return;

    setState(() {
      // Add tapped point to the list
      polygonPoints.add(point);

      // Add a marker for the point
      markers.add(
        Marker(
          markerId: MarkerId('point_${polygonPoints.length}'),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () => _onMarkerTapped(point), // Handle marker tap
        ),
      );

      // Update the polygon
      _updatePolygon();
    });
  }

  void _onMarkerTapped(LatLng markerPosition) {
    print('Marker tapped: $markerPosition');
    setState(() {
      // Check if the marker position is already part of the polygon
      if (!polygonPoints.contains(markerPosition)) {
        polygonPoints.add(markerPosition); // Add marker to polygon points
        _updatePolygon(); // Update the polygon
      }
    });
  }

  void _clearPolygon() {
    setState(() {
      // clear markers except the current location marker
      markers.removeWhere((marker) => marker.markerId != MarkerId('current_location'));
      polygonPoints.clear();
      polygons.clear();
    });
  }

  void _handleClear() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Anda yakin ingin menghapus?').titleLarge(),
              Divider(),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _clearPolygon();
                        Navigator.pop(context);
                      },
                      child: Text('Ya'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Tidak'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSave() {
    // Save the polygon
    print('Polygon points: $polygonPoints');
    // list of polygon points string lat,lng
    final result = polygonPoints.map((point) => [point.latitude, point.longitude]).toList();
    pop(result: result);
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Infra/Sungai").titleLarge(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          onPressed: () {
            pop();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                markers: markers,
                mapType: MapType.terrain,
                polygons: polygons,
                initialCameraPosition: CameraPosition(
                  target: LatLng(initialLocation.latitude, initialLocation.longitude),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                onTap: _onMapTapped,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: !isDrawingPolygon &&
                polygonPoints.isNotEmpty &&
                polygonPoints.last != LatLng(initialLocation.latitude, initialLocation.longitude),
            child: FloatingActionButton(
              heroTag: 'save',
              onPressed: () {},
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  _handleSave();
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'edit',
            onPressed: () {},
            child: IconButton(
              icon: Icon(isDrawingPolygon ? Icons.stop : Icons.edit),
              onPressed: () {
                setState(() {
                  isDrawingPolygon = !isDrawingPolygon;
                });
              },
            ),
          ),
          SizedBox(width: 16),
          Visibility(
            visible: polygonPoints.isNotEmpty &&
                polygonPoints.last != LatLng(initialLocation.latitude, initialLocation.longitude),
            child: FloatingActionButton(
              heroTag: 'clear',
              onPressed: _handleClear,
              child: Icon(Icons.clear),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.large(
      //   onPressed: () {},
      //   child: IconButton(
      //     icon: Icon(isDrawingPolygon ? Icons.stop : Icons.edit),
      //     onPressed: () {
      //       setState(() {
      //         isDrawingPolygon = !isDrawingPolygon;
      //       });
      //     },
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
