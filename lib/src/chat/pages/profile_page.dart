import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/contact.dart';
import 'chat_page.dart';

class ProfilePage extends StatelessWidget {
  final double _height;
  final double _width;

  ProfilePage(this._height, this._width);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
    );
  }
}
