import 'package:cricket/LoginPages/signUpPage.dart';
import 'package:cricket/HomePage.dart';
import 'package:cricket/Widget/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  static const routeName = "/";
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  String _emailAddress;
  String _password;

  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //Retrieve the user information from SharedPreferences for login
  Future<void> _retrieveUser() async {
    final prefs = await SharedPreferences.getInstance();

    // Check where the email is saved before or not
    if (!prefs.containsKey('email')) {
      return;
    }
    _emailAddress = prefs.getString('email');
    _password = prefs.getString('password');
    prefs.setString('isLoggedIn', 'yes');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login to Cricket',
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/cricket.png',
                      fit: BoxFit.cover,
                      height: 90,
                      width: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _emailAddressController,
                          label: 'Email Address',
                          obscureText: false,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(Icons.email),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "* Email address is required"),
                            EmailValidator(
                                errorText: '* It should be an email address')
                          ]),
                        ),
                        CustomTextFormField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: _obscureText,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "* Password is required"),
                            MinLengthValidator(6,
                                errorText:
                                    "Password should be at least 6 characters"),
                            MaxLengthValidator(15,
                                errorText:
                                    "Password should not be greater than 15 characters")
                          ]),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kInActiveColor,
                              size: 23,
                            ),
                            onPressed: _toggle,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus.unfocus();
                              if (_formKey.currentState.validate()) {
                                _retrieveUser().then((value) {
                                  if (_emailAddressController.text ==
                                      _emailAddress) {
                                    if (_passwordController.text == _password) {
                                      Navigator.pushReplacementNamed(
                                          context, HomePage.routeName);
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'Wrong Password',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Not fount such account',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  }
                                });
                                print("Validated");
                              } else {
                                print("Not Validated");
                              }
                            },
                            child: Text('Login'),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignUpPage.routeName,
                            );
                          },
                          child: Text(
                            'Register now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
