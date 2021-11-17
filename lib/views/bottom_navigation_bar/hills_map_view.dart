import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class HillsMapView extends StatelessWidget {
  final LatLng otu = LatLng(43.944459, -78.896465);

  HillsMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(center: otu, zoom: 16.0),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/tayloryoung/ckw2deumz3jo614rtffqghrre/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGF5bG9yeW91bmciLCJhIjoiY2t3MjU0eWN4MGE5YjMxcHhsMjRpd3A0OSJ9.7UmX8FwS_dQQXNd5lgKQIA",
        ),
      ],
    );
  }
}
