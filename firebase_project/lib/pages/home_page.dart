import 'package:flutter/material.dart';
import 'package:flutter_04_05/db/db_sqlite.dart';
import 'package:flutter_04_05/firebase_helper/authentication_helper.dart';
import 'package:flutter_04_05/models/product_model.dart';
import 'package:flutter_04_05/pages/cart_page.dart';
import 'package:flutter_04_05/pages/login_page.dart';
import 'package:flutter_04_05/pages/new_product_page.dart';
import 'package:flutter_04_05/widgets/product_item.dart';
import 'package:flutter_04_05/db/db_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => CartPage()
            )),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => NewProductPage()
            )).then((_) {
              setState(() {

              });
            }),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if(value == 0) {
                //go to profile page
              }else if(value == 1) {
                AuthenticationHelper.logout().then((_) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginPage()
                  ));
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('My Profile'), value: 0,),
              PopupMenuItem(child: Text('Logout'), value: 1,),
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: DBFireStore.getProducts(),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if(snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: snapshot.data.map((product) => ProductItem(product, refresh)).toList(),
            );
          }
          if(snapshot.hasError) {
            return Center(child: Text('Failed to fetch data'),);
          }
          return Center(child: CircularProgressIndicator(),);
        }

      ),
    );
  }
}
