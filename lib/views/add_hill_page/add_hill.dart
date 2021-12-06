import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:tobogganapp/firestore_helper.dart';

class add_hill extends StatelessWidget {
  const add_hill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Hill"),
          backgroundColor: Colors.blue,
        ),
        body: const addHillWidget());
  }
}

class addHillWidget extends StatefulWidget {
  const addHillWidget({Key? key}) : super(key: key);

  @override
  State<addHillWidget> createState() => _addHillState();
}

class _addHillState extends State<addHillWidget> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  XFile? _featuredPhoto;
  ImagePicker _picker = ImagePicker();
  String _information = '';
  LatLng? _geopoint;
  String? _address;
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<Location> _searchResults = [];
  String _searchQuery = "";
  LatLng _userLocation = LatLng(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              _featuredPhoto == null
                  ? const Icon(Icons.photo_camera, size: 75)
                  : Image.file(File(_featuredPhoto!.path), height: 75),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  // if no photo added, let user add one
                  if (_featuredPhoto == null) {
                    var image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      // null if no image selected
                      _featuredPhoto = image;
                    });
                  } else {
                    // else, remove photo
                    setState(() {
                      _featuredPhoto = null;
                    });
                  }
                },
                child: Text(
                    _featuredPhoto == null ? "Add Photo" : "Remove photo",
                    style: const TextStyle(fontSize: 20)),
              )
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Hill name', style: TextStyle(fontSize: 16)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      label:
                          Text('Information', style: TextStyle(fontSize: 16)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hill information';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _information = value!;
                    },
                  ),
                )
              ],
            ),
          ),
          const Text("Tap map to select location for hill"),
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                      center: LatLng(43.944459, -78.896465),
                      zoom: 16.0,
                      onTap: (pos, latlong) async {
                        _address = await getAddress(
                            latlong.latitude, latlong.longitude);
                        setState(() {
                          //print(_address);
                          _geopoint = latlong;
                          _markers = [
                            Marker(
                              point: latlong,
                              builder: (context) {
                                return const CircleAvatar(
                                  child: Icon(Icons.sledding),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                );
                              },
                            )
                          ];
                        });
                      }),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/tayloryoung/ckw2deumz3jo614rtffqghrre/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGF5bG9yeW91bmciLCJhIjoiY2t3MjU0eWN4MGE5YjMxcHhsMjRpd3A0OSJ9.7UmX8FwS_dQQXNd5lgKQIA",
                    ),
                    MarkerLayerOptions(markers: _markers)
                  ],
                ),
                buildFloatingSearchBar()
              ],
            ),
          ),
          Text("Location: ${_address ?? "Nothing selected"}"),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              _formKey.currentState!.validate();
              String snackBarMessage;
              // make sure user has filled in all information
              if (_address == null ||
                  _featuredPhoto == null ||
                  _geopoint == null ||
                  _name.isEmpty ||
                  _information.isEmpty) {
                snackBarMessage = "Not all information has been filled out!";
              } else {
                // add the hill to the database
                await FirestoreHelper.addHill(
                    _name,
                    _featuredPhoto!,
                    _address!,
                    _information,
                    GeoPoint(_geopoint!.latitude, _geopoint!.longitude));
                snackBarMessage = "Added hill!";
                Navigator.pop(context);
              }
              SnackBar snackBar = SnackBar(content: Text(snackBarMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Center(
                child: Text("Add Hill", style: TextStyle(fontSize: 20))),
          )
        ],
      ),
    );
  }

  Future<String> getAddress(double latitude, double longitude) async {
    List<Placemark> places =
        await placemarkFromCoordinates(latitude, longitude);

    return "${places.first.street}, ${places.first.locality}, ${places.first.administrativeArea}";
  }

  // Modified from example at https://pub.dev/packages/material_floating_search_bar
  Widget buildFloatingSearchBar() {
    final FloatingSearchBarController searchController =
        FloatingSearchBarController();
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: searchController,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      automaticallyImplyBackButton: false,
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      onSubmitted: (search) async {
        List<Location> locations = [];
        _searchQuery = search;

        // if theres no results let the user know, else update search results
        try {
          locations = await locationFromAddress(search);
        } on NoResultFoundException {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("No results when searching for $search.")));
        }

        // update the body of the floating search bar with the new results
        setState(() {
          _searchResults = locations;
        });
      },
      clearQueryOnClose: false,
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () async {
              var position = await _getCurrentPosition();
              setState(() {
                _userLocation = LatLng(position.latitude, position.longitude);
                _mapController.move(
                    LatLng(position.latitude, position.longitude), 16.0);
              });
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    var location = _searchResults[index];
                    return ListTile(
                      leading: const Icon(Icons.location_pin),
                      title: Text(_searchQuery),
                      subtitle:
                          Text("(${location.latitude}, ${location.longitude})"),
                      onTap: () {
                        // Close and clear the search bar
                        searchController.close();
                        searchController.clear();
                        _searchQuery = "";
                        // move the map center to the newly selected location
                        var latlng =
                            LatLng(location.latitude, location.longitude);
                        _mapController.move(latlng, 16.0);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Position> _getCurrentPosition() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    }

    await Geolocator.requestPermission();
    return Position(
        latitude: 43.944459,
        longitude: -78.896465,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
  }
}
