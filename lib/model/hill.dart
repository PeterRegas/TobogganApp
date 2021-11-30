import 'package:latlong2/latlong.dart';
import 'package:tobogganapp/model/review.dart';

class Hill {
  String hillID;
  String name;
  String featuredPhoto;
  String address;
  String information;
  LatLng geopoint;
  List<Review> reviews;
  List<String> photos;

  int get rating {
    // computed from the average of all rating
    return 5;
  }

  Hill(this.hillID, this.name, this.featuredPhoto, this.address,
      this.information, this.geopoint, this.reviews, this.photos);
}
