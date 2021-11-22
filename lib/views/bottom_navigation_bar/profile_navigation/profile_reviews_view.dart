import 'package:flutter/material.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class Review {
  String text;
  double rating;
  String location;

  Review(this.text, this.rating, this.location);
}

//Updated version will use

class _ReviewViewState extends State<ReviewView> {
  List<Review> testList = [
    Review("The fitnessgram pacer test is a multistage aerobic capacity test",
        10.0, "Gym"),
    Review("Someone stole my pants, 0/10", 0, "Grand Canyon"),
    Review("I had a great time! Would come again!", 9.0, "OnTech U"),
    Review("I'm lost please help me", 5.0, "????"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: testList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 0),
            child: Column(
              children: [
                ListTile(
                  title: Text(testList[index].location),
                  subtitle: Text("Rating: ${testList[index].rating}/10.0"),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Text(testList[index].text),
                ),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
