import 'dart:async';
import 'dart:convert' as JSON;
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';
import 'package:map_app/constants.dart';

StreamController<double> controller = StreamController.broadcast();

class PickAdressWidget extends StatefulWidget {
  const PickAdressWidget({
    super.key,
    required this.onAdressSelected,
  });
  final ValueChanged<Place?> onAdressSelected;
  @override
  State<PickAdressWidget> createState() => _PickAdressWidgetState();
}

class _PickAdressWidgetState extends State<PickAdressWidget> {
  double position = 200.0;
  List<Widget> _children = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) => GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                position = MediaQuery.of(context).size.height -
                    details.globalPosition.dy;

                if (position > size.height * .07 * 10) {
                  position = size.height * .07 * 10;
                } else if (position < size.height * .14) {
                  position = size.height * .07;
                } else {
                  position.isNegative ? null : controller.add(position);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                height:
                    snapshot.hasData ? snapshot.data : size.height * .07 * 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey4,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    SizedBox(
                        height: size.height * 0.07,
                        child: TextField(
                          onChanged: (value) {
                            _makeRequest(value).then((value) {
                              _children = [];
                              for (var p in value) {
                                _children.add(ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  minLeadingWidth: 30,
                                  onTap: () {
                                    widget.onAdressSelected(p);
                                  },
                                  leading: Icon(
                                    CupertinoIcons.map_pin_ellipse,
                                    size: 30,
                                    color: CupertinoColors.darkBackgroundGray
                                        .withOpacity(.75),
                                  ),
                                  title: Text(p.description ?? '',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors
                                              .darkBackgroundGray
                                              .withOpacity(.75))),
                                ));
                              }
                              setState(() {});
                            });
                          },
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 20.0),
                            border: InputBorder.none,
                            hintText: 'Pick up location',
                            hintStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            labelStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            suffixIcon: CircleAvatar(
                              backgroundColor: CupertinoColors.systemGrey6,
                              child: InkWell(
                                onTap: () {
                                  getUserLocation().then((v) {
                                    Placemark place = v['address'];
                                    Position position = v['position'];
                                    print(
                                        '${place.street} ${place.name} ${place.country}');
                                    _makeRequest(
                                            '${place.street} ${place.locality} ${place.country} ${place.administrativeArea}}')
                                        .then((value) {
                                      _children = [];
                                      for (var p in value) {
                                        _children.add(ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          minLeadingWidth: 30,
                                          onTap: () {
                                            widget.onAdressSelected(p);
                                          },
                                          leading: Icon(
                                            CupertinoIcons.map_pin_ellipse,
                                            size: 30,
                                            color: CupertinoColors
                                                .darkBackgroundGray
                                                .withOpacity(.75),
                                          ),
                                          title: Text(p.description ?? '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: CupertinoColors
                                                      .darkBackgroundGray
                                                      .withOpacity(.75))),
                                        ));
                                      }
                                      setState(() {});
                                    });
                                  });
                                },
                                child: const Icon(
                                  CupertinoIcons.map,
                                  size: 30,
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                            ),
                            prefixIcon: const Icon(
                              CupertinoIcons.play,
                              size: 30,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        )),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: ListView(
                        children: _children,
                        // itemCount: 10,
                        // itemBuilder: (context, index) {
                        //   return ListTile(
                        //     contentPadding:
                        //         const EdgeInsets.symmetric(horizontal: 5),
                        //     minLeadingWidth: 30,
                        //     onTap: () {

                        //       widget.onAdressSelected(null);
                        //     },
                        //     leading: Icon(
                        //       CupertinoIcons.map_pin_ellipse,
                        //       size: 30,
                        //       color: CupertinoColors.darkBackgroundGray
                        //           .withOpacity(.75),
                        //     ),
                        //     title: Text("object",
                        //         style: TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             color: CupertinoColors.darkBackgroundGray
                        //                 .withOpacity(.75))),
                        //   );
                        // }
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}

Future<Map<dynamic, dynamic>> getUserLocation() async {
  Map<dynamic, dynamic> map = {
    'address': null,
    'position': null,
  };
  Position position = await _determinePosition();
  var addresses =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  map['address'] = addresses.first;
  print(map['address']);
  map['position'] = position;
  return map;
}

Future<Position> _determinePosition() async {
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

  return await Geolocator.getCurrentPosition();
}

Future<List<Place>> _makeRequest(String input,
    {Position? location,
    double? radius,
    bool strictBounds = false,
    PlaceType? placeType,
    String language = 'en'}) async {
  Geocoding? geocode = Geocoding(apiKey: apiKey, language: language);

  List<Place> places = [];

  String url =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=$language";
  if (location != null && radius != null) {
    url +=
        "&location=${location.latitude},${location.longitude}&radius=$radius";
    if (strictBounds) {
      url += "&strictbounds";
    }
    if (placeType != null) {
      url += "&types=${placeType.apiString}";
    }
  }

  final response = await http.get(Uri.parse(url));
  final json = JSON.jsonDecode(response.body);

  if (json["error_message"] != null) {
    var error = json["error_message"];
    if (error == "This API project is not authorized to use this API.") {
      error +=
          " Make sure the Places API is activated on your Google Cloud Platform";
    }
    throw Exception(error);
  } else {
    final predictions = json["predictions"];
    print(json);
    for (var prediction in predictions) {
      places.add(Place.fromJSON(prediction, geocode));
    }

    return places;
  }
}
