import 'package:flutter/material.dart';
import './../../models/app_state_model.dart';
import '../../blocs/checkout_bloc.dart';
import '../../models/customer_model.dart';
import '../../models/register_model.dart';
import '../color_override.dart';
import 'login/button_text.dart';
import 'login/buttons.dart';

class RegisterForm extends StatefulWidget {
  final appStateModel = AppStateModel();
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  var _register = Register();

  TextEditingController firstNameController = new TextEditingController();

  TextEditingController lastNameController = new TextEditingController();

  TextEditingController phoneNumberController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text(widget.appStateModel.blocks.localeText.signUp),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Center(
          child: new Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText:  widget.appStateModel.blocks.localeText.firstName,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.appStateModel.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText:  widget.appStateModel.blocks.localeText.lastName,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.appStateModel.blocks.localeText.pleaseEnterLastName;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: widget.appStateModel.blocks.localeText.phoneNumber,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.appStateModel.blocks.localeText.pleaseEnterPhoneNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: widget.appStateModel.blocks.localeText.email,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.appStateModel.blocks.localeText.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: widget.appStateModel.blocks.localeText.password,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.appStateModel.blocks.localeText.pleaseEnterPassword;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 22.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        child: ButtonText(isLoading: isLoading, text: widget.appStateModel.blocks.localeText.signUp),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _register.firstName = firstNameController.text;
                            _register.lastName = lastNameController.text;
                            _register.phoneNumber = phoneNumberController.text;
                            _register.email = emailController.text;
                            _register.password = passwordController.text;
                            setState(() {
                              isLoading = true;
                            });
                            bool status = await widget.appStateModel.register(_register.toJson());
                            setState(() {
                              isLoading = false;
                            });
                            if(status) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}