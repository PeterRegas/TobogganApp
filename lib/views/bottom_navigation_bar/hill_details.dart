import 'package:flutter/material.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/model/hill.dart';
import '../review_page/review_page.dart';

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
  AddEvent(this.hill, {Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
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
                            child: Image.network(
                                "https://images.unsplash.com/photo-1545325343-33b85a319d90?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80"),
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
                                        text: "200 Simcoe St, North",
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
                            child: StarDisplay(value: 3),
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
                    Text("Add Photo"),
                  ],
                )),
                VerticalDivider(),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.person_add)),
                    Text("Check In"),
                  ],
                )),
                VerticalDivider(),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
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
                              child: Text('Display Tab 2',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Center(
                              child: Text('Display Tab 3',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
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
  const StarDisplay({this.value = 0}) : assert(value != null);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
