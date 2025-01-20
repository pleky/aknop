import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/identifikasi_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
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

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  get init => () {};

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
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
