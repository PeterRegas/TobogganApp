import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tobogganapp/model/hill.dart';

class HillInfoBottomSheet extends StatelessWidget {
  const HillInfoBottomSheet(this.hill, this.userLocation, {Key? key})
      : super(key: key);

  final Hill hill;
  final LatLng userLocation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        height: 120,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hill.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                starsForRating(hill.rating),
                const SizedBox(width: 10),
                Text(
                    hill.reviews.length == 1
                        ? "${hill.reviews.length} review"
                        : "${hill.reviews.length} reviews",
                    style: const TextStyle(color: Colors.grey, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text("${hill.address} ⋅ ${hill.distanceFrom(userLocation)}km",
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget starsForRating(double rating) {
    return Row(
      children: [
        Icon(Icons.star,
            color: rating.round() >= 1 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color: rating.round() >= 2 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color: rating.round() >= 3 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color: rating.round() >= 4 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color: rating.round() >= 5 ? Colors.amber : Colors.grey),
      ],
    );
  }
}
