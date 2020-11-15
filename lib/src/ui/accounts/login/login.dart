import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/app_state_model.dart';
import '../../../blocs/checkout_bloc.dart';
import '../../../models/customer_model.dart';
import '../../color_override.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'button_text.dart';
import 'buttons.dart';
import 'phone_verification.dart';

//**** UNCOMMENT THSI FOR GOOGLE AND FB SIGN IN *****//
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

//import 'package:apple_sign_in/apple_sign_in.dart';
//import 'package:flutter_account_kit/flutter_account_kit.dart';


//**** UNCOMMENT THSI FOR GOOGLE AND FB SIGN IN *****//
//final GoogleSignIn _googleSignIn = GoogleSignIn();

bool isLoggedIn = false;

class Login extends StatefulWidget {
  final appStateModel = AppStateModel();
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameControler = new TextEditingController();
  TextEditingController passwordControler = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  String _phoneNumber;

  //String verificationId;

  String smsOTP;

  String errorMessage = '';

  var isLoading = false;
  bool isSocilaLogin = false;
  bool isLoadingApple =false;
  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.appStateModel.blocks.localeText.signIn),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Form(
            key: _formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PrimaryColorOverride(
                  child: TextFormField(
                    controller: usernameControler,
                    decoration: InputDecoration(
                      labelText: widget.appStateModel.blocks.localeText.username,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterUsername;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 12.0),
                PrimaryColorOverride(
                  child: TextFormField(
                    controller: passwordControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: widget.appStateModel.blocks.localeText.password
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText.pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 40.0),
                RaisedButton(
                  child: ButtonText(isLoading: isLoading, text: widget.appStateModel.blocks.localeText.signIn),
                  onPressed: () => isLoading ? null : _login(),
                ),
                SizedBox(height: 40.0),
          /*Container(
                    width: double.infinity,
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                    child: new Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: new FlatButton(
                          onPressed: () => isLoadingApple ? null : appleLogIn(),
                          shape: new RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)), side: BorderSide.none,),
                          child: isLoadingApple
                              ? new Container(
                            width: 20.0,
                            height: 20.0,
                            child: new Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.black : Colors.white),
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                )),
                          ) : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Image(
                          image: AssetImage(
                                    "lib/assets/images/apple_logo_${Theme.of(context).colorScheme.brightness == Brightness.dark ? "black" : "white"}.png",
                                  ),
                                height: 15.0,
                                width: 15.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                AppLocalizations.of(context).signInWithApple,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),*/
                /*Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              shape: StadiumBorder(),
                              margin: EdgeInsets.all(4),
                              color: Color(0xFFEA4335),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.google,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _googleLogin();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              shape: StadiumBorder(),
                              margin: EdgeInsets.all(4),
                              color: Color(0xFF3b5998),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.facebook,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _fbLogin();
                                  },
                                ),
                              ),
                            ),
                            Card(
                              shape: StadiumBorder(),
                              margin: EdgeInsets.all(4),
                              color: Color(0xFF34B7F1),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.sms,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    dynamic response = await showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) => new PhoneVerification(
                                          fullscreen: false,
                                          //logo: Container(),
                                        ));
                                    if(response == true){
                                      Navigator.of(context).pop();
                                    }

                                  },
                                ),
                              ),
                            ),
                            *//*Card(
                              shape: StadiumBorder(),
                              margin: EdgeInsets.all(4),
                              color: Color(0xFF128C7E),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: IconButton(
                                  color: Colors.red,
                                  icon: Icon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                   accountKitLogin();
                                  },
                                ),
                              ),
                            ),*//*
                          ],
                        )),
                  ),
                ),*/
              ],
            ),
          ),
        ));
  }

  //Apple_Sign_In

  /*appleLogIn() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:

          var login = new Map<String, dynamic>();
          if(result.credential.email != null)
          login["email"] = result.credential.email;
          else login["email"] = result.credential.user;
          if(result.credential.fullName.givenName != null)
          login["name"] = result.credential.fullName.givenName;
          else login["name"] = '';
          setState(() {
            isSocilaLogin = true;
          });
          bool status = await widget.appStateModel.googleLogin(login);
          setState(() {
            isSocilaLogin = false;
          });
          if (status) {
            Navigator.of(context).pop();
          }

          break; //All the required credentials
        case AuthorizationStatus.error:
          break;
        case AuthorizationStatus.cancelled:
          break;
      }
    } else {
      
    }
  }*/

  void onLogin(Map<String, dynamic> login) async {
    setState(() {
      isLoading = true;
    });
    bool status = await widget.appStateModel.login(login);
    setState(() {
      isLoading = false;
    });
    if (status) {
      Navigator.of(context).pop();
    }
  }

  ///Google SignIn
//**** UNCOMENT THSI FOR GOOGLE AND FB SIGN IN *****//


  /*_googleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    var login = new Map<String, dynamic>();
    login["name"] = googleUser.displayName;
    login["email"] = googleUser.email;
    bool status = await widget.appStateModel.googleLogin(login);
    if (status) {
      Navigator.of(context).pop();
    }
  }*/

  ///Fb SignIn

  /*_fbLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _sendTokenToServer(result.accessToken.token);
        _showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        _showErrorOnUI(result.errorMessage);
        break;
    }
  }*/


  Future _sendTokenToServer(token) async {
    bool status = await widget.appStateModel.facebookLogin(token);
    if (status) {
      Navigator.of(context).pop();
    }
  }

  void _showLoggedInUI() {}

  void _showCancelledMessage() {}

  void _showErrorOnUI(String errorMessage) {
    
  }

  _login() async {
    var login = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      login["username"] = usernameControler.text;
      login["password"] = passwordControler.text;
      onLogin(login);
    }
  }

  // Account Kit Loggin
  /*Future<void> accountKitLogin() async {
    FlutterAccountKit akt = new FlutterAccountKit();
    LoginResult result = await akt.logInWithPhone();

    switch (result.status) {
      case LoginStatus.loggedIn:
        _sendTokenToServer(result.accessToken.token);
        _showLoggedInUI();
        break;
      case LoginStatus.cancelledByUser:
        _showCancelledMessage();
        break;
      case LoginStatus.error:
        _showErrorOnUI('Login Failed');
        break;
    }
  }*/



}
