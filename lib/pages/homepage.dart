import 'package:ecommm/pages/cart_page.dart';
// import 'package:ecommm/product_Card.dart';
// import 'package:ecommm/product_details_page.dart';
import 'package:ecommm/widgets/product_list.dart';
import 'package:flutter/material.dart';
// import 'package:ecommm/global_variables.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  int currentPage=0;
  List<Widget> pages= const[
    ProductList(),
    CartPage()
  ];

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }
}