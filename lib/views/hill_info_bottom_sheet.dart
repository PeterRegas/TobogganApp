import 'package:flutter/material.dart';

class HillInfoBottomSheet extends StatelessWidget {
  const HillInfoBottomSheet(this.name, {Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber)
                ],
              ),
              const SizedBox(width: 10),
              const Text("9 reviews",
                  style: TextStyle(color: Colors.grey, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Text("200 Simcoe St. North ⋅ 12km",
                  style: TextStyle(color: Colors.grey, fontSize: 16))
            ],
          )
        ],
      ),
    );
  }
}
