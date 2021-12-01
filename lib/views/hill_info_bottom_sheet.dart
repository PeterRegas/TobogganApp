import 'package:flutter/material.dart';
import 'package:tobogganapp/model/hill.dart';

class HillInfoBottomSheet extends StatelessWidget {
  const HillInfoBottomSheet(this.hill, {Key? key}) : super(key: key);

  final Hill hill;

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
                Text("${hill.address} ⋅ 12km",
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
      children: const [
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star_outline, color: Colors.amber),
        Icon(Icons.star_half, color: Colors.amber)
      ],
    );
  }
}
