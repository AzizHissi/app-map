import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/constants.dart';

class MapModel extends ChangeNotifier {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  void addMarker(LatLng latLng, bool isDestination) async {
    final id = _markers.length;
    _markers.add(Marker(
        markerId: MarkerId(id.toString()),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(isDestination
            ? BitmapDescriptor.hueGreen
            : BitmapDescriptor.hueRed)));

    notifyListeners();

    if (!isDestination) {
      final GoogleMapController ctr = await controller.future;
      ctr.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 10)));
    }
  }

  void addPolyline() async {
    if (_markers.length < 2) return;
    // _polylines.clear();
    final id = _polylines.length;
    GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: apiKey);
    List<LatLng>? lsi = await googleMapPolyline.getCoordinatesWithLocation(
        origin: _markers.first.position,
        destination: _markers.last.position,
        mode: RouteMode.walking);

    Polyline polyline = Polyline(
      polylineId: PolylineId('$id'),
      color: Colors.blue,
      width: 5,
      points: lsi ?? [],
    );
    _polylines.add(polyline);
    notifyListeners();
  }
}
