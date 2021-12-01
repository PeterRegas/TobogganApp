import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/hill.dart';
import 'package:tobogganapp/views/bottom_navigation_bar/hill_details.dart';
import 'package:tobogganapp/views/hill_info_bottom_sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HillsMapView extends StatefulWidget {
  const HillsMapView({Key? key}) : super(key: key);

  @override
  State<HillsMapView> createState() => _HillsMapViewState();
}

class _HillsMapViewState extends State<HillsMapView> {
  final MapController _mapController = MapController();
  late LatLng _userLocation;
  String _searchQuery = "";
  List<Location> _searchResults = [];
  List<Marker> _markers = [];
  // keeps track of what marker we have selected, helps change the marker's colour
  int _selectedMarkerIndex = -1;

  @override
  void initState() {
    loadMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              center: LatLng(43.944459, -78.896465),
              zoom: 16.0,
              onTap: (pos, latlong) {
                // hide the bottom sheet if visible
                if (Navigator.of(context).canPop()) {
                  // set state needed to toggle marker colour
                  setState(() {
                    _selectedMarkerIndex = -1;
                    Navigator.of(context).pop();
                  });
                }
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
    );
  }

  Future<void> loadMarkers() async {
    // fetch most recent position if available, else return current position
    var lastKnownPosition = await Geolocator.getLastKnownPosition();
    var position = lastKnownPosition ?? await _getCurrentPosition();

    // load the markers
    List<Hill> hills = await FirestoreHelper.getAllHills();
    List<Marker> hillMarkers = [];
    for (int i = 0; i < hills.length; i++) {
      hillMarkers.add(getMarker(hills[i], i));
    }

    setState(() {
      _markers = hillMarkers;
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Marker getMarker(Hill hill, int index) {
    return Marker(
      point: hill.geopoint,
      builder: (BuildContext context) {
        return GestureDetector(
          child: CircleAvatar(
            child: const Icon(Icons.sledding),
            foregroundColor: Colors.white,
            // blue if showing sheet, else black
            backgroundColor:
                _selectedMarkerIndex == index ? Colors.blue : Colors.black,
          ),
          onTap: () {
            // set state needed to update marker colour
            setState(() {
              // if we are currently showing a bottom sheet
              if (Navigator.of(context).canPop()) {
                // remove current sheet
                Navigator.of(context).pop();
                // if the marker selected is not equal to this marker
                if (_selectedMarkerIndex != index) {
                  // show new bottom sheet (for different hill) and update index
                  _selectedMarkerIndex = index;
                  Scaffold.of(context).showBottomSheet(
                      (context) => HillInfoBottomSheet(hill, _userLocation));
                } else {
                  // User re-selected the currently selected marker
                  _selectedMarkerIndex = -1;
                }
              } else {
                // No marker currently selected, show the sheet for the hill
                _selectedMarkerIndex = index;
                Scaffold.of(context).showBottomSheet(
                  (context) => GestureDetector(
                    child: HillInfoBottomSheet(hill, _userLocation),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Hilldetails()));
                    },
                  ),
                );
              }
            });
          },
        );
      },
    );
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
