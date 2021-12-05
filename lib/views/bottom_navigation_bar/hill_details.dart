import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/hill.dart';
import '../review_page/review_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Hilldetails extends StatelessWidget {
  Hill hill;
  Hilldetails(this.hill, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hill Details"),
      ),
      body: AddEvent(hill),
    );
  }
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AddEvent extends StatefulWidget {
  Hill hill;
  List<Image> photos = [];
  AddEvent(this.hill, {Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  initState() {
    loadPhotos();
    super.initState();
  }

  loadPhotos() async {
    var photos = await widget.hill.photos;
    setState(() {
      widget.photos = photos;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    List<XFile>? imageUrl = [];

    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView(
        children: [
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                      child: Row(children: [
                    Flexible(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 5),
                            child: widget.hill.featuredPhoto,
                          ),
                        )),
                  ])),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                child: Text(
                                  widget.hill.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                padding: EdgeInsets.only(left: 5))),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                      TextSpan(
                                        text: widget.hill.address,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      )
                                    ])))),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: IconTheme(
                            data: IconThemeData(
                              color: Colors.amber,
                            ),
                            child:
                                StarDisplay(value: 3, hillObject: widget.hill),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          Divider(),
          Flexible(
              flex: 1,
              child: Row(children: [
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                // ignore: prefer_const_constructors
                                builder: (context) =>
                                    (ReviewPage(hillObject: widget.hill))),
                          );
                        },
                        icon: Icon(Icons.star)),
                    Text("Review"),
                  ],
                )),
                VerticalDivider(),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                        onPressed: () async {
                          var images = await picker.pickMultiImage();
                          String userID =
                              FirebaseAuth.instance.currentUser!.uid;
                          FirestoreHelper.addNonReviewPhoto(
                              widget.hill.hillID,
                              userID,
                              await FirestoreHelper.getNameForUserId(userID),
                              images!);
                          setState(() {
                            var snackBar =
                                SnackBar(content: Text('Photo(s) Added!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                          // pop current review page and show
                          var hillWithUpdatedDetails =
                              (await FirestoreHelper.getHillForHillId(
                                  widget.hill.hillID))!;
                          // pop away hill page
                          Navigator.of(context).pop();
                          // show hill detail again
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Hilldetails(hillWithUpdatedDetails);
                          }));
                        },
                        icon: Icon(Icons.camera_alt)),
                    Text("Add Photo"),
                  ],
                )),
                VerticalDivider(),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                        onPressed: () async {
                          var isBookmarked = FirestoreHelper.isHillBookmarked(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.hill.hillID);
                          if (await isBookmarked == true) {
                            var snackBar =
                                SnackBar(content: Text('Bookmark Removed!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (await isBookmarked == false) {
                            var snackBar =
                                SnackBar(content: Text('BookMark Added!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          FirestoreHelper.toggleHillBookmarkFor(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.hill.hillID);

                          setState(() {});
                        },
                        icon: Icon(Icons.bookmark)),
                    Text("Bookmark"),
                  ],
                )),
              ])),
          Divider(),
          Flexible(
            flex: 6,
            child: DefaultTabController(
                length: 3, // length of tabs
                initialIndex: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(text: 'Info'),
                            Tab(text: 'Photos'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                      ),
                      Container(
                          height: 400, //height of TabBarView
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5))),
                          child: TabBarView(children: <Widget>[
                            Center(
                              child: Text('Display Tab 1',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Center(
                                child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemCount: widget.photos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: widget.photos[index],
                                  onTap: () {
                                    // navigate to photo detail
                                  },
                                );
                              },
                            )
                                // child: ListView.separated(
                                //   separatorBuilder:
                                //       (BuildContext context, int index) =>
                                //           const Divider(),
                                //   itemCount: widget.hill.photos.length,
                                //   itemBuilder: (context, index) {
                                //     return widget.hill.photos[index];
                                //   },
                                // ),
                                ),
                            Center(
                              child: ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemCount: widget.hill.reviews.length,
                                itemBuilder: (context, index) {
                                  return Expanded(
                                    child: Column(
                                      children: [
                                        StarDisplayUser(
                                            review: widget
                                                .hill.reviews[index].rating),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(
                                              widget.hill.reviews[index]
                                                  .reviewText,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(
                                              widget.hill.reviews[index]
                                                  .reviewerName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]))
                    ])),
          )
        ],
      ),
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;
  Hill? hillObject;
  StarDisplay({this.value = 0, this.hillObject});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.star,
            color:
                hillObject!.rating.round() >= 1 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color:
                hillObject!.rating.round() >= 2 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color:
                hillObject!.rating.round() >= 3 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color:
                hillObject!.rating.round() >= 4 ? Colors.amber : Colors.grey),
        Icon(Icons.star,
            color:
                hillObject!.rating.round() >= 5 ? Colors.amber : Colors.grey),
      ],
    );
  }
}

class StarDisplayUser extends StatelessWidget {
  int? review;
  StarDisplayUser({this.review});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.star, color: review! >= 1 ? Colors.amber : Colors.grey),
        Icon(Icons.star, color: review! >= 2 ? Colors.amber : Colors.grey),
        Icon(Icons.star, color: review! >= 3 ? Colors.amber : Colors.grey),
        Icon(Icons.star, color: review! >= 4 ? Colors.amber : Colors.grey),
        Icon(Icons.star, color: review! >= 5 ? Colors.amber : Colors.grey),
      ],
    );
  }
}
