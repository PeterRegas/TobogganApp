import 'package:flutter/material.dart';
import '/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
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
    double maxHeight = MediaQuery.of(context).size.height;
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5),

            // width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Email', style: TextStyle(fontSize: 16)),
                      // icon: Icon(Icons.email),
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
                      label: Text('Password', style: TextStyle(fontSize: 16)),
                      // icon: Icon(Icons.password),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print('$_email $_password');
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => MyHomePage()),
                        // );
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
                ])));
  }
}
