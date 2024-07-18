import 'package:assignment/item_screen.dart';
import 'package:assignment/sub_folders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Categories',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  categoryGrid(),
                ],
              ))),
    );
  }

  Widget categoryGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('folders')
                .where('parent_folder', isEqualTo: '')
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return categoryTile(
                          snapshot.data!.docs[index].data(), context);
                    });
              }
            })),
      ),
    );
  }

  Widget categoryTile(docData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        docData['hasChildFolders']
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Subfolders(parentFolder: docData['folder_name'])),
              )
            : getImages(docData['folder_name'], context);
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.lightGreen),
        child: Text(
          docData['folder_name'],
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20.0),
        ),
      ),
    );
  }

  void getImages(folderName, BuildContext context) {
    try {
      FirebaseFirestore.instance
          .collection('Images')
          .doc(folderName.toString().toLowerCase())
          .get()
          .then((snapshot) {
        final data = snapshot.data();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ItemScreen(
                    docName: folderName,
                    docData: data?['items'],
                  )),
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
