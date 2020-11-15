import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  final String url;

  const ImageView({Key key, this.url}) : super(key: key);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                child: PhotoView(
              imageProvider: NetworkImage(widget.url),
            )),
            Positioned(
                top: 32,
                left: 16,
                child: IconButton(
                    icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        width: 35,
                        height: 35,
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 18,)
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
          ],
        ),
      ),
    );
  }
}
