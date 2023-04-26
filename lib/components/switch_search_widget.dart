import 'package:flutter/material.dart';
import 'package:map_app/MapModel.dart';
import 'package:map_app/components/pick_adress_widget.dart';
import 'package:map_app/components/search_result_widget.dart';
import 'package:map_app/components/select_date_widget.dart';
import 'package:map_app/components/select_passengers_widget.dart';

import 'initial_search_widget.dart';

class SwitchSearchWidgets extends StatefulWidget {
  const SwitchSearchWidgets({super.key, required this.mapModel});

  final MapModel mapModel;

  @override
  State<SwitchSearchWidgets> createState() => _SwitchSearchWidgetsState();
}

class _SwitchSearchWidgetsState extends State<SwitchSearchWidgets> {
  bool _isInitialeSearchWidget = true;
  bool _isSelectDateWidget = false;
  bool _isSelectPassengersWidget = false;
  bool _isSelectPickWidget = false;
  bool _isSelectDestinationWidget = false;
  bool _isSelectSearchWidget = false;
  String? pickAdress;
  String? destinationAddress;
  String? date;
  String? passengers;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: _isInitialeSearchWidget
            ? InitialeSearchWidget(
                pickAddress: pickAdress,
                destinationAddress: destinationAddress,
                date: date,
                passenger: passengers,
                onSwitchClick: () {
                  String? temp = pickAdress;
                  pickAdress = destinationAddress;
                  destinationAddress = temp;
                  setState(() {});
                },
                onDestinationPressed: () {
                  setState(() {
                    _isInitialeSearchWidget = false;
                    _isSelectDestinationWidget = true;
                  });
                },
                onSearchPressed: () {
                  setState(() {
                    _isInitialeSearchWidget = false;
                    _isSelectSearchWidget = true;
                  });
                },
                onPickPressed: () {
                  setState(() {
                    _isInitialeSearchWidget = false;
                    _isSelectPickWidget = true;
                  });
                },
                onDatePressed: () {
                  setState(() {
                    _isInitialeSearchWidget = false;
                    _isSelectDateWidget = true;
                  });
                },
                onPassengersPressed: () {
                  setState(() {
                    _isInitialeSearchWidget = false;
                    _isSelectPassengersWidget = true;
                  });
                })
            : _isSelectPassengersWidget
                ? SelectPassengersWidget(
                    onPassengersSelected: (value) {
                      setState(() {
                        _isInitialeSearchWidget = true;
                        _isSelectPassengersWidget = false;
                        passengers = value.toString();
                      });
                    },
                  )
                : _isSelectDateWidget
                    ? SelectDateWidget(
                        onDateSelected: (value) {
                          setState(() {
                            date = value == null
                                ? null
                                : '${value.day}-${value.month}-${value.year}';
                            _isInitialeSearchWidget = true;
                            _isSelectDateWidget = false;
                          });
                        },
                      )
                    : _isSelectPickWidget
                        ? PickAdressWidget(
                            onAdressSelected: (value) {
                              value?.geolocation?.then((value) {
                                widget.mapModel
                                    .addMarker(value?.coordinates, false);
                              });
                              setState(() {
                                pickAdress = value?.description;
                                _isInitialeSearchWidget = true;
                                _isSelectPickWidget = false;
                              });
                            },
                          )
                        : _isSelectDestinationWidget
                            ? PickAdressWidget(
                                onAdressSelected: (value) {
                                  value?.geolocation?.then((value) {
                                    widget.mapModel
                                        .addMarker(value?.coordinates, true);
                                  });
                                  setState(() {
                                    destinationAddress = value?.description;
                                    _isInitialeSearchWidget = true;
                                    _isSelectDestinationWidget = false;
                                  });
                                },
                              )
                            : _isSelectSearchWidget
                                ? const SearchResultWidget()
                                : const Center());
  }
}
