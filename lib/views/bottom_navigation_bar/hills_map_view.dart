import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:tobogganapp/views/hill_info_bottom_sheet.dart';

class HillsMapView extends StatefulWidget {
  const HillsMapView({Key? key}) : super(key: key);

  @override
  State<HillsMapView> createState() => _HillsMapViewState();
}

class _HillsMapViewState extends State<HillsMapView> {
  final LatLng otu = LatLng(43.944459, -78.896465);
  final LatLng otu2 = LatLng(43.945905, -78.897293);
  // keeps track of what marker we have selected, helps change the marker's colour
  int _selectedMarkerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
              center: otu,
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
            MarkerLayerOptions(markers: [
              getMarker(otu, 0, "OTU Park"),
              getMarker(otu2, 1, "OTU Library Hill")
            ])
          ],
        ),
        buildFloatingSearchBar()
      ],
    );
  }

  Marker getMarker(LatLng point, int index, String hillName) {
    return Marker(
      point: point,
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
                      (context) => HillInfoBottomSheet(hillName));
                } else {
                  // User re-selected the currently selected marker
                  _selectedMarkerIndex = -1;
                }
              } else {
                // No marker currently selected, show the sheet for the hill
                _selectedMarkerIndex = index;
                Scaffold.of(context).showBottomSheet(
                    (context) => HillInfoBottomSheet(hillName));
              }
            });
          },
        );
      },
    );
  }

  // Modified from example at https://pub.dev/packages/material_floating_search_bar
  Widget buildFloatingSearchBar() {
    final FloatingSearchBarController controller =
        FloatingSearchBarController();
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
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
      onSubmitted: (search) {
        print(search);
        controller.close();
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return Container();
      },
    );
  }
}
