import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ItemView extends StatefulWidget {
  final String imageUrl;
  const ItemView({super.key, required this.imageUrl});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Item View',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: PhotoView(
                imageProvider: NetworkImage(
              widget.imageUrl,
            )),
          ),
        ),
      ),
    );
  }
}
