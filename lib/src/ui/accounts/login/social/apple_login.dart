import './../../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;

class AppleLogin extends StatelessWidget {

  final appStateModel = AppStateModel();

  AppleLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      margin: EdgeInsets.all(0),
      color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF000000),
      child: Container(
        height: 50,
        width: 50,
        child: IconButton(
          //splashRadius: 25.0,
          icon: Icon(
            FontAwesomeIcons.apple,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
          onPressed: () {
            appleLogIn(context);
          },
        ),
      ),
    );
  }

  appleLogIn(BuildContext context) async {

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'com.aboutyou.dart_packages.sign_in_with_apple.example',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );

    if(credential.authorizationCode != null) {
      print(credential.authorizationCode);
      var login = new Map<String, dynamic>();
      login["userIdentifier"] = credential.userIdentifier;
      if(credential.authorizationCode != null)
        login["authorizationCode"] = credential.authorizationCode;
      if(credential.email != null)
        login["email"] = credential.email;
      if(credential.userIdentifier != null)
        login["email"] = credential.userIdentifier;
      if(credential.givenName != null)
        login["name"] = credential.givenName;
      else login["name"] = '';
      login["useBundleId"] = Platform.isIOS || Platform.isMacOS ? 'true' : 'false';
      print(credential.authorizationCode);
      bool status = await appStateModel.appleLogin(login);
      if (status) {
        Navigator.of(context).pop();
      }
    }



/*    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      print(result.status);
      switch (result.status) {
        case AuthorizationStatus.authorized:

          var login = new Map<String, dynamic>();
          if(result.credential.email != null)
            login["email"] = result.credential.email;
          else login["email"] = result.credential.user;
          if(result.credential.fullName.givenName != null)
            login["name"] = result.credential.fullName.givenName;
          else login["name"] = '';

          bool status = await appStateModel.appleLogin(login);

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

    }*/
  }
}
