import 'package:ecommm/widgets/product_Card.dart';
import 'package:ecommm/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:ecommm/global_variables.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    "All",
    "men's clothing",
    "women's clothing",
    "jewelery",
    "electronics"
  ];
  
  late String selectedFilter;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await ProductService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
        right: Radius.circular(50),
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Shoes \nCollection",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    filled: true,
                    fillColor: Color.fromRGBO(119, 119, 119, 0.1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      label: Text(filter),
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      backgroundColor: selectedFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const Color.fromRGBO(119, 119, 119, 0.1),
                      side: BorderSide(
                        color: const Color.fromRGBO(119, 119, 119, 0.1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      
                      if (selectedFilter != "All" && 
                          product['company'] != selectedFilter) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: {
                                  'id': product['id'],
                                  'title': product['title'],
                                  'price': product['price'],
                                  'sizes': product['sizes'] ?? [8.0, 8.5, 9.0, 9.5, 10.0], // Default sizes
                                  'company': product['company'],
                                  'imageUrl': product['imageUrl'],
                                },
                              ),
                            ),
                          );
                        },
                        child: ProductCard(
                          title: product['title'] as String,
                          price: product['price'] as double,
                          image: product['imageUrl'] as String,
                          backgroundColor: index.isEven
                              ? const Color.fromRGBO(216, 240, 253, 1)
                              : const Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}