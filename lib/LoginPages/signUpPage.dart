import 'package:cricket/HomePage.dart';
import 'package:cricket/LoginPages/signInPage.dart';
import 'package:cricket/Widget/customTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = "sign_up_page";
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //Saving the user information to SharedPreferences for login and Signup
  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailAddressController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('isLoggedIn', 'yes');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              SignInPage.routeName,
            ),
          ),
          title: Text(
            'Create new Account',
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
                                print("Validated");
                                _saveUser().then((value) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    HomePage.routeName,
                                  );
                                });
                              } else {
                                print("Not Validated");
                              }
                            },
                            child: Text('Create'),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Wrap(
                          children: [
                            Text('Already registered? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                )),
                            InkWell(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                SignInPage.routeName,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
