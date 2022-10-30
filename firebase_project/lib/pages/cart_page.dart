import 'package:flutter/material.dart';
import 'package:flutter_04_05/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).removeAll();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, provider, child) => ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(provider.cartItems[index].name),
                    trailing: Chip(
                      backgroundColor: Colors.blue,
                      label: Text('TK.${provider.cartItems[index].price}',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                itemCount: provider.itemCount,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.blue,
            child: Consumer<CartProvider>(
              builder: (context, provider, child) => Text('Total Price: ${provider.totalPrice}',
              style: TextStyle(fontSize: 25, color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}
