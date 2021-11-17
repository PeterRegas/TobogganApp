import 'package:flutter/material.dart';

class HillsListView extends StatelessWidget {
  const HillsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return const HillInfoCard();
      },
    );
  }
}

class HillInfoCard extends StatelessWidget {
  const HillInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
              "https://images.unsplash.com/photo-1545325343-33b85a319d90?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80"),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Row(children: const [
                  Text(
                    "OTU Park",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                ]),
                Row(children: const [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber),
                  SizedBox(width: 10),
                  Text("(9 reviews)")
                ]),
                Row(children: const [
                  Text("200 Simcoe St. North ⋅ 12km",
                      style: TextStyle(color: Colors.grey)),
                ]),
                const SizedBox(height: 30),
                Row(
                  children: [
                    TextButton(onPressed: () {}, child: const Text("BOOKMARK")),
                    TextButton(
                        onPressed: () {}, child: const Text("DIRECTIONS"))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
