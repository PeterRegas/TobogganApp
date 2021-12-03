import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/hill.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bottom_navigation_bar/hill_details.dart';

class HillsListView extends StatefulWidget {
  const HillsListView({Key? key}) : super(key: key);

  @override
  State<HillsListView> createState() => _HillsListViewState();
}

class _HillsListViewState extends State<HillsListView> {
  List<Hill> _hills = [];
  bool _loadedHills = false;
  late LatLng _userLocation;

  @override
  void initState() {
    loadHills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loadedHills
        ? ListView.builder(
            itemCount: _hills.length,
            itemBuilder: (BuildContext context, int index) {
              return HillInfoCard(_hills[index], _userLocation);
            })
        : const Center(child: CircularProgressIndicator());
  }

  Future<void> loadHills() async {
    // fetch user location and store it, helps show distance to hill
    var loc = await Geolocator.getLastKnownPosition();

    // fetch the hills and sort by closest distance to user
    List<Hill> hills = await FirestoreHelper.getAllHills();
    hills.sort((a, b) {
      return a
          .distanceFrom(LatLng(loc!.latitude, loc.longitude))
          .compareTo(b.distanceFrom(LatLng(loc.latitude, loc.longitude)));
    });

    setState(() {
      _userLocation = LatLng(loc!.latitude, loc.longitude);
      _loadedHills = true;
      _hills = hills;
    });
  }
}

class HillInfoCard extends StatelessWidget {
  final Hill _hill;
  final LatLng _userLocation;

  const HillInfoCard(this._hill, this._userLocation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Hilldetails(_hill)));
      },
      child: Card(
        child: Column(
          children: [
            _hill.featuredPhoto,
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Row(children: [
                    Text(
                      _hill.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ]),
                  Row(children: [
                    Icon(Icons.star,
                        color: _hill.rating.round() >= 1
                            ? Colors.amber
                            : Colors.grey),
                    Icon(Icons.star,
                        color: _hill.rating.round() >= 2
                            ? Colors.amber
                            : Colors.grey),
                    Icon(Icons.star,
                        color: _hill.rating.round() >= 3
                            ? Colors.amber
                            : Colors.grey),
                    Icon(Icons.star,
                        color: _hill.rating.round() >= 4
                            ? Colors.amber
                            : Colors.grey),
                    Icon(Icons.star,
                        color: _hill.rating.round() >= 5
                            ? Colors.amber
                            : Colors.grey),
                    const SizedBox(width: 10),
                    Text("(" +
                        (_hill.reviews.length == 1
                            ? "${_hill.reviews.length} review"
                            : "${_hill.reviews.length} reviews") +
                        ")")
                  ]),
                  Row(children: [
                    Text(
                        "${_hill.address} ⋅ ${_hill.distanceFrom(_userLocation)}km",
                        style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {}, child: const Text("BOOKMARK")),
                      TextButton(
                          onPressed: () async {
                            // launch directions to hill
                            String url =
                                "https://www.google.com/maps/dir/?api=1&destination=${_hill.address}}";
                            await launch(Uri.encodeFull(url));
                          },
                          child: const Text("DIRECTIONS"))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
