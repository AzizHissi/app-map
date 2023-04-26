import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MapModel.dart';
import 'components/switch_search_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool isLoading = true;
  MapModel mapModel = MapModel();

  late CameraPosition _kGooglePlex;

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  void initState() {
    _determinePosition();
    mapModel.addListener(() {
      setState(() {});
      mapModel.addPolyline();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? const Center()
              : GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  markers: mapModel.markers,
                  polylines: mapModel.polylines,
                  onMapCreated: (GoogleMapController controller) {
                    mapModel.controller.complete(controller);
                    
                  },
                ),
          Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leadingWidth: size.width * 0.15 + 10,
                leading: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                              child: Center(
                            child: Icon(
                              Icons.sort,
                              color: Colors.black,
                              size: 35,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Center(
                          child: Icon(
                            CupertinoIcons.add_circled,
                            color: Colors.black,
                            size: 35,
                          ),
                        )),
                        const VerticalDivider(
                          color: Colors.black,
                          endIndent: 5,
                          indent: 5,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            // print(_kGooglePlex);
                            // mapModel.addMarker(LatLng(
                            //     _kGooglePlex.target.latitude,
                            //     _kGooglePlex.target.longitude) , false);
                          },
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.bell,
                              color: Colors.black,
                              size: 35,
                            ),
                          ),
                        )),
                      ],
                    ),
                  )
                ],
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SwitchSearchWidgets(
                mapModel: mapModel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _determinePosition() async {
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

    Position pos = await Geolocator.getCurrentPosition();

    _kGooglePlex = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 14.4746);
    isLoading = false;
    setState(() {});
  }
   
}
