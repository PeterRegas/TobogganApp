import 'package:flutter/material.dart';

class PhotoDetail extends StatelessWidget {
  final Image image;
  final String hillName;

  const PhotoDetail(this.image, this.hillName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hillName)),
      body: Center(child: image),
    );
  }
}
