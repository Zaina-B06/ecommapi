import 'package:ecommm/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final cartItem = cart[index];

          return ListTile(
            leading: _buildCartItemImage(cartItem['imageUrl'] as String),
            trailing: IconButton(
              onPressed: () {
                _showDeleteDialog(context, cartItem);
              }, 
              icon: const Icon(
                Icons.delete, 
                color: Colors.red,
              ),
            ),
            title: Text(
              cartItem['title'].toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text('Size: ${cartItem['size']}'),
          );
        },
      ),
    );
  }

  Widget _buildCartItemImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 25,
      );
    } else {
      return CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
        radius: 25,
      );
    }
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> cartItem) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Product?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: const Text("Are you sure you want to remove the product?"),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                  .removeProduct(cartItem);
                Navigator.of(context).pop();
              }, 
              child: const Text(
                "Yes", 
                style: TextStyle(color: Colors.blue),
              )
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text(
                "No", 
                style: TextStyle(color: Colors.red),
              )
            ),
          ],
        );
      }
    );
  }
}