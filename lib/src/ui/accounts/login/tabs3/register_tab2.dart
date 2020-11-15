import 'dart:io';

import './../../../color_override.dart';

import './../../../../models/app_state_model.dart';
import './../../../../models/register_model.dart';
import './../../login/social/apple_login.dart';
import './../../login/social/facebook_login.dart';
import './../../login/social/google_login.dart';
import './../../login/social/sms_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../button_text.dart';

class RegisterTab extends StatefulWidget {

  RegisterTab({Key key, @required this.context,
    @required this.model,
    @required this.tabController,}) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TabController tabController;
  final appStateModel = AppStateModel();
  @override
  _RegisterTabState createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  //Country _selected = Country.IN;
  Map loginData =  Map<String, dynamic>();
  bool _obscureText;
  String radioItem = '';
  var _register = Register();
  var isLoading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child:  Form(
              key: _formKey,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 120,
                    constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
                    child: Image.asset(
                      'lib/assets/images/logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(
                    height: 30,),
                  PrimaryColorOverride(
                    child: TextFormField(
                      onSaved: (val) =>
                          setState(() => _register.firstName = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: widget.model.blocks.localeText.firstName),
                    ),
                  ),
                  SizedBox(height: 12,),
                  PrimaryColorOverride(
                    child: TextFormField(
                      onSaved: (val) =>
                          setState(() => _register.lastName = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterLastName;
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: widget.model.blocks.localeText.lastName),
                    ),
                  ),
                  SizedBox(height: 12,),
                  PrimaryColorOverride(
                    child: TextFormField(
                      onSaved: (val) =>
                          setState(() => _register.email = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: widget.model.blocks.localeText.email),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 12,),
                  PrimaryColorOverride(
                    child: TextFormField(
                      onSaved: (val) =>
                          setState(() => _register.password = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterPassword;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.password,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.signUp),
                      onPressed: () => isLoading ? null : _registerUser(context),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: Text(
                      widget.model.blocks.localeText.or,
                      style: TextStyle(fontSize: 15,
                          color: Colors.grey),),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Container(
                              height: 50.0, // height of the button
                              width: 50.0,
                              child: GoogleLoginWidget(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Container(
                              height: 50.0, // height of the button
                              width: 50.0,
                              child: FacebookLoginWidget(),
                            ),
                          ),
                        ),
                        Platform.isIOS ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Container(
                              height: 50.0, // height of the button
                              width: 50.0,
                              child: AppleLogin(),
                            ),
                          ),
                        ) : Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Container(
                              height: 50.0, // height of the button
                              width: 50.0,
                              child: SmsLogin(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {
                        widget.tabController.animateTo(0);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              widget.model.blocks.localeText
                                  .alreadyHaveAnAccount,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontSize: 15,
                                  color: Colors.grey)),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                                widget.model.blocks.localeText.signIn,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color:
                                    Theme.of(context).accentColor)),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ]);
  }

  Future _registerUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      bool status =
      await widget.model.register(_register.toJson());
      setState(() {
        isLoading = false;
      });
      if (status) {
        Navigator.of(context).pop();
      }
    }
  }

  Container buildIcon(child) {
    return Container(
      width: 30,
      height: 30,
      child: child,
    );
  }

  void onLogin() async {
    print(loginData);
  }

  countrySelector() {
    /*return CountryPicker(
      dense: false,
      showFlag: false,  //displays flag, true by default
      showDialingCode: false, //displays dialing code, false by default
      showName: true, //displays country name, true by default
      showCurrency: true, //eg. 'British pound'
      showCurrencyISO: true, //eg. 'GBP'
      onChanged: (Country country) {
        setState(() {
          _selected = country;
        });
      },
      selectedCountry: _selected,
    );*/
  }
}
class CustomTextFormField extends StatelessWidget {
  bool password;
  bool obscureText;
  IconButton suffix;
  String label;
  String validationMsg;
  TextEditingController controller;
  IconData icon;
  TextInputType inputType;
  FormFieldSetter onSaved;

  CustomTextFormField(
      {this.label,
        this.validationMsg,
        this.controller,
        this.icon,
        this.obscureText,
        this.inputType,
        this.password,
        this.suffix,
        this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      onSaved: onSaved,
      validator: (value) {
        if (value.isEmpty) {
          return validationMsg;
        }
        return null;
      },
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(.4)),
          ),
          suffixIcon: suffix,
          labelText: label,
          labelStyle: TextStyle(
              fontFamily: 'Monteserrat',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey.withOpacity(.4)
          ),),
      keyboardType: inputType,
    );
  }
}