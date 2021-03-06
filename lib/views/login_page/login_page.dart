// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tobogganapp/firestore_helper.dart';
import 'package:tobogganapp/views/create_account/create_account.dart';
import '/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Login'),
      //   automaticallyImplyLeading: false,
      // ),
      body: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email = '';
  String? _password = '';

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    // double maxHeight = MediaQuery.of(context).size.height;
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 60),

          // width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
                    label: Text('Email', style: TextStyle(fontSize: 16)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    label: Text('Password', style: TextStyle(fontSize: 16)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(maxWidth, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _email!, password: _password!);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          // fetch user data for ProfileView
                          String uid = FirebaseAuth.instance.currentUser!.uid;
                          String name =
                              await FirestoreHelper.getNameForUserId(uid);
                          int numOfReviews =
                              (await FirestoreHelper.getReviewsForUser(uid))
                                  .length;
                          int numOfPhotos =
                              (await FirestoreHelper.getPhotosForUser(uid))
                                  .length;
                          Position pos =
                              await Geolocator.getLastKnownPosition() ??
                                  // default to OTU if no last known position
                                  Position(
                                      latitude: 43.944459,
                                      longitude: -78.896465,
                                      heading: 0.0,
                                      speed: 0.0,
                                      accuracy: 0.0,
                                      speedAccuracy: 0.0,
                                      altitude: 0.0,
                                      timestamp: DateTime.now());
                          Placemark placemark = (await placemarkFromCoordinates(
                              pos.latitude, pos.longitude))[0];

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage(
                                      name,
                                      "${placemark.locality}, ${placemark.administrativeArea}",
                                      numOfReviews,
                                      numOfPhotos)));
                        } on FirebaseAuthException catch (e) {
                          if ((e.code == 'user-not-found') ||
                              (e.code == 'wrong-password')) {
                            final snackBar = SnackBar(
                              content:
                                  const Text('Incorrect email or password.'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      }
                    },
                    child: Text('LOG IN',
                        style: TextStyle(
                          fontSize: 16,
                        ))),
                SizedBox(
                  height: 40,
                ),
                Row(children: <Widget>[
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  SizedBox(width: 5),
                  Text("OR"),
                  SizedBox(width: 5),
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  )),
                ]),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(maxWidth, 50),
                      primary: Colors.grey[700],
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccountPage()),
                      );
                    },
                    child: Wrap(children: [
                      Icon(
                        Icons.person_add,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text('CREATE ACCOUNT',
                          style: TextStyle(
                            fontSize: 16,
                          ))
                    ])),
              ])),
        ));
  }
}
