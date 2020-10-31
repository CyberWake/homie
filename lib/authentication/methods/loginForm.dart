import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_temperature/auth/userAuth.dart';
import 'package:home_temperature/authentication/helpers/authButtons.dart';
import 'package:home_temperature/authentication/helpers/formFiledFormatting.dart';
import 'package:home_temperature/authentication/helpers/validation.dart';
import 'package:home_temperature/authentication/methods/socialRegisterUsername.dart';
import 'package:home_temperature/models/enums.dart';
import 'package:home_temperature/models/theme.dart';
import 'package:home_temperature/models/userDataModel.dart';
import 'package:home_temperature/screens/mainScreen.dart';

class LoginForm extends StatefulWidget {
  final ValueChanged<AuthIndex> changeMethod;
  LoginForm({this.changeMethod});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  UserDataModel _userDataModel = UserDataModel();
  UserAuth _userAuth = UserAuth();
  double _widthOne;
  double _heightOne;
  double _fontOne;
  Size _size;
  bool _loginForm = true;
  bool _hidePassword = true;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _widthOne = _size.width * 0.0008;
    _heightOne = (_size.height * 0.007) / 5;
    _fontOne = (_size.height * 0.015) / 11;
    return _loginForm ? loginForm() : SocialRegisterUsername();
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _widthOne * 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: _heightOne * 83,
            ),
            _emailField(),
            SizedBox(
              height: _heightOne * 10,
            ),
            _passwordFiled(),
            SizedBox(
              height: _heightOne * 15,
            ),
            _loginButton(context),
            SizedBox(
              height: _heightOne * 22,
            ),
            InkWell(
              onTap: () {
                widget.changeMethod(AuthIndex.FORGOT);
              },
              child: Text(
                "Forgot Password?\nReset it here",
                style: TextStyle(color: Colors.black, fontSize: _fontOne * 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: _heightOne * 34.2,
            ),
            Text(
              "Or Login With",
              style: TextStyle(color: Colors.grey, fontSize: _fontOne * 15),
            ),
            SizedBox(
              height: _heightOne * 10,
            ),
            AuthButtons.socialLogin(
                newAccountCallback: () {
                  setState(() {
                    _loginForm = false;
                  });
                },
                context: context,
                size: _size),
            SizedBox(
              height: _heightOne * 20,
            ),
            InkWell(
              onTap: () {
                widget.changeMethod(AuthIndex.REGISTER);
              },
              child: Text(
                "Don't Have an account? \nTap here to register.",
                style: TextStyle(color: Colors.black, fontSize: _fontOne * 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: _heightOne * 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return FormFieldFormatting.formFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: FormValidation.validateEmail,
        onChanged: (val) {
          _userDataModel.email = val;
          if (_submitted) {
            _formKey.currentState.validate();
          }
        },
        decoration: FormFieldFormatting.formFieldFormatting(
            hintText: "Enter Email", fontSize: _fontOne * 15),
        style: TextStyle(
          fontSize: _fontOne * 15,
        ),
      ),
      leftPadding: _widthOne * 20,
    );
  }

  Widget _passwordFiled() {
    return FormFieldFormatting.formFieldContainer(
      child: TextFormField(
        obscureText: _hidePassword,
        validator: FormValidation.validateLoginPassword,
        onChanged: (val) {
          _userDataModel.password = val;
          if (_submitted) {
            _formKey.currentState.validate();
          }
        },
        decoration: FormFieldFormatting.formFieldFormatting(
          suffixIcon: IconButton(
            icon: Icon(
              _hidePassword ? Icons.visibility : Icons.visibility_off,
              color: AppTheme.primaryColor,
            ),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          ),
          hintText: "Enter Password",
          fontSize: _fontOne * 15,
        ),
        style: TextStyle(fontSize: _fontOne * 15),
      ),
      leftPadding: _widthOne * 20,
    );
  }

  Widget _loginButton(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            await _userAuth
                .signInWithEmailAndPassword(
              email: _userDataModel.email,
              password: _userDataModel.password,
              context: context,
            )
                .then((result) {
              if (result == null) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Something went wrong try again')));
              } else if (result == "success") {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => MainScreen(
                              title: "Homie",
                            )));
              } else {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(result)));
              }
            });
          } else {
            setState(() {
              _submitted = true;
            });
          }
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side:
                BorderSide(color: AppTheme.primaryColor, width: _widthOne * 5)),
        splashColor: Colors.orange[100],
        padding: EdgeInsets.symmetric(horizontal: _size.width * 0.29),
        child: Text(
          "Login",
          style: TextStyle(
            color: AppTheme.primaryColor,
          ),
        ));
  }
}
