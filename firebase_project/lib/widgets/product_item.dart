import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_04_05/db/db_firestore.dart';
import 'package:flutter_04_05/db/db_sqlite.dart';
import 'package:flutter_04_05/models/product_model.dart';
import 'package:flutter_04_05/pages/product_details_page.dart';
import 'package:flutter_04_05/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final Function callback;
  ProductItem(this.product, this.callback);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  CartProvider cartProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context);
    super.didChangeDependencies();
  }

  void _update() {
    var value = widget.product.isFavorite ? 0 : 1;
    /*DBSqlite.updateIsFav(widget.product.id, value).then((value) {
      setState(() {
        widget.product.isFavorite = !widget.product.isFavorite;
      });
    });*/
    DBFireStore.updateFavorite(widget.product.id, value).then((_) {
      setState(() {
        widget.product.isFavorite = !widget.product.isFavorite;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: Icon(Icons.delete, color: Colors.white, size: 60,),
      ),
      onDismissed: (direction) {
        DBFireStore.deleteProduct(widget.product.id).then((_) {
          widget.callback();
        });
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete ${widget.product.name}?'),
              content: Text('Are you sure to delete this product? You cannot undo this operation!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                RaisedButton(
                    child: Text('Delete'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    }
                ),
              ],
            )
        );
      },

      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProductDetailsPage(widget.product.id)
        )),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          elevation: 5,
          child: Column(
            children: <Widget>[
              widget.product.imageDownloadUrl == null ?
              Image.file(File(widget.product.imagePath), height: 200, width: double.infinity, fit: BoxFit.cover,)
               : Image.network(widget.product.imageDownloadUrl, height: 200, width: double.infinity, fit: BoxFit.cover,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product.name, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis,),
              ),
              Expanded(
                child: Text('Tk.${widget.product.price}', style: TextStyle(fontSize: 18),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(widget.product.isFavorite ? Icons.favorite : Icons.favorite_border),
                      onPressed: _update,
                    ),
                    cartProvider.cartItems.contains(widget.product) ? Icon(Icons.done) : IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        cartProvider.addToCart(widget.product);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
