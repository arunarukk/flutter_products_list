import 'dart:async';

import 'package:e_commerce_app/controller/control.dart';
import 'package:e_commerce_app/model/procucts_model.dart';
import 'package:e_commerce_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  List<Product> filteredProducts = [];
  SortOrder currentSortOrder = SortOrder.ascending;

  void sortProducts(SortOrder sortOrder) {
    setState(() {
      currentSortOrder = sortOrder;
      if (currentSortOrder == SortOrder.ascending) {
        filteredProducts.sort((a, b) => a.title!.compareTo(b.title!));
      } else {
        filteredProducts.sort((a, b) => b.title!.compareTo(a.title!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductListProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await provider.getAllProducts();
      provider.filteredProducts = provider.products;
    });
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 10,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade200,
                  ),
                  child: TextField(
                    onChanged: provider.filterProducts,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        hintText: 'Search',
                        border: InputBorder.none),
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Consumer<ProductListProvider>(
                      builder: (context, value, child) {
                        return DropdownButton<SortOrder>(
                          value: value.currentSortOrder,
                          onChanged: (query) {
                            value.sortProducts(query!);
                          },
                          items: const [
                            DropdownMenuItem(
                              value: SortOrder.ascending,
                              child: Text('Ascending'),
                            ),
                            DropdownMenuItem(
                              value: SortOrder.descending,
                              child: Text('Descending'),
                            ),
                          ],
                        );
                      },
                    )),
              ],
            ),
          ),
          Expanded(
            child:
                Consumer<ProductListProvider>(builder: (context, value, child) {
              if (value.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (value.isError) {
                return Center(
                  child: Text('Error occured !'),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                // physics: (),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                itemCount: value.filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: Colors.grey.shade200,
                    title: Text(value.filteredProducts[index].title!),
                    subtitle: Text(
                        '\$${value.filteredProducts[index].price!.toStringAsFixed(2)}'),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
