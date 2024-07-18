import 'package:assignment/categories.dart';
import 'package:assignment/item_view.dart';
import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import 'package:shimmer/shimmer.dart';

class ItemScreen extends StatelessWidget {
  final String docName;
  final docData;
  const ItemScreen({
    super.key,
    required this.docName,
    this.docData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          docName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Categories()));
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: docData != null
          ? PageFlipWidget(children: <Widget>[
              for (var i = 0; i < setIterate(); i++) itemGrid(i, docData)
            ])
          : const Center(
              child: Text('No Images Available'),
            ),
    );
  }

  Widget itemGrid(int itemCount, itemList) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: setItemCount(itemCount, itemList.length),
        itemBuilder: (context, index) {
          return itemCard(itemList[(itemCount * 8) + index], context);
        },
      ),
    );
  }

  Widget itemCard(imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemView(
                      imageUrl: imageUrl,
                    )));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (ctx) => itemViewDialogBox(imageUrl, context),
        );
      },
      child: SizedBox(
        child: Image.network(
          imageUrl,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            final totalBytes = loadingProgress?.expectedTotalBytes;
            final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
            if (totalBytes != null && bytesLoaded != null) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const Icon(
                    Icons.image,
                    size: 100,
                  ));
            } else {
              return child;
            }
          },
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: child,
            );
          },
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Text(
              'An Error Occured',
              style: TextStyle(color: Colors.red),
            );
          },
        ),
      ),
    );
  }

  Widget itemViewDialogBox(imageUrl, BuildContext context) {
    return PopScope(
        child: AlertDialog(
      content: SizedBox(
        height: 200,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemView(
                          imageUrl: imageUrl,
                        )));
          },
          child: Image.network(
            imageUrl,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              final totalBytes = loadingProgress?.expectedTotalBytes;
              final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
              if (totalBytes != null && bytesLoaded != null) {
                return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(
                      Icons.image,
                      size: 100,
                    ));
              } else {
                return child;
              }
            },
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                child: child,
              );
            },
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Text(
                'An Error Occured',
                style: TextStyle(color: Colors.red),
              );
            },
          ),
        ),
      ),
    ));
  }

  int setIterate() {
    double temp = docData.length / 8;
    if (temp % 1 == 0) {
      return temp.floor();
    } else {
      return temp.floor() + 1;
    }
  }

  int setItemCount(itemCount, length) {
    if (itemCount * 8 > length) {
      return (itemCount * 8) - length;
    } else {
      if (length - (itemCount * 8) > 8) {
        return 8;
      } else {
        return length - (itemCount * 8);
      }
    }
  }
}
