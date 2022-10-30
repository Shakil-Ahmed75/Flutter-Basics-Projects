import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_04_05/db/db_firestore.dart';
import 'package:flutter_04_05/db/db_sqlite.dart';
import 'package:flutter_04_05/models/product_model.dart';
import 'package:flutter_04_05/utils/product_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewProductPage extends StatefulWidget {
  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();
  Product product = Product();
  String category = 'Electronics';
  String date;
  String imagePath;
  bool isLoading = false;
  void _pickDate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now()
    ).then((dateTime) {
      setState(() {
        date = DateFormat('dd/MM/yyyy').format(dateTime);
      });
      product.date = date;
    });

  }

  void _takePicture() async {
    PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imagePath = pickedFile.path;
    });
    product.imagePath = imagePath;
    /*ImagePicker().getImage(source: ImageSource.camera).then((file) {
      print(file.path);
      setState(() {
        imagePath = file.path;
      });
      product.imagePath = imagePath;
    });*/
  }

  void _saveProduct() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      if(date == null) {
        return;
      }
      if(imagePath == null) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      print(product);
      /*DBSqlite.insertProduct(product).then((id) {
        if(id > 0) {
          Navigator.pop(context);
        }else{
          print('failed to save');
        }
      });*/

      final StorageReference storageReference = FirebaseStorage.instance.ref()
      .child('Flutter Batch 04/${DateTime.now().millisecondsSinceEpoch}');
      
      final uploadTask = storageReference.putFile(File(product.imagePath));
      final snapShot = await uploadTask.onComplete;
      snapShot.ref.getDownloadURL().then((url) {
        product.imageDownloadUrl = url.toString();
        DBFireStore.addProduct(product).then((_) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }).catchError((error) {
          throw error;
        });
      }).catchError((error) {
        throw error;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Product'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Product Name'
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if(value.length < 6) {
                        return 'Product name should be greater than 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      product.name = value;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Product Price'
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'This field must not be empty';
                      }
                      if(double.parse(value) <= 0.0) {
                        return 'Product price should be greater than 0';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      product.price = double.parse(value);
                    },
                  ),
                  SizedBox(height: 10,),
                  Text('Select Category'),
                  DropdownButton(
                    value: category,
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                      product.category = category;
                    },
                    items: categoryList.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    )).toList(),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Select Date'),
                        onPressed: _pickDate,
                      ),
                      Text(date == null ? 'No date chosen yet' : date, style: TextStyle(fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey)
                        ),
                        child: imagePath == null ? Text('No image chosen') : Image.file(File(imagePath)),
                      ),
                      FlatButton.icon(onPressed: _takePicture, icon: Icon(Icons.camera), label: Text('Take Photo'))
                    ],
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.blue,
                    child: Text('Save', style: TextStyle(color: Colors.white),),
                    onPressed: _saveProduct,
                  )
                ],
              ),
            ),
          ),
          if(isLoading) Center(child: CircularProgressIndicator(),)
        ],
      ),
    );
  }
}
