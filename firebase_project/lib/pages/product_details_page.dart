import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_04_05/db/db_firestore.dart';
import 'package:flutter_04_05/db/db_sqlite.dart';
import 'package:flutter_04_05/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final int id;
  ProductDetailsPage(this.id);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: FutureBuilder(
        future: DBFireStore.getProductById(widget.id),
        builder: (context, AsyncSnapshot<Product> snapshot) {
          if(snapshot.hasData) {
            return Column(
              children: <Widget>[
                Image.file(File(snapshot.data.imagePath), width: double.infinity, height: 300, fit: BoxFit.cover,),
              ],
            );
          }
          if(snapshot.hasError) {
            return Center(child: Text('Failed to fetch data'),);
          }
          return Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }
}
