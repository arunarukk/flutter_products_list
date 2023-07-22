import 'dart:developer';

import 'package:e_commerce_app/model/procucts_model.dart';
import 'package:e_commerce_app/services/api_services.dart';
import 'package:flutter/foundation.dart';

class ProductListProvider extends ChangeNotifier {
  final getAll = GetProducts();
  List<Product> products = [];
  bool isLoading = false;
  bool isError = false;

  List<Product> filteredProducts = [];
  SortOrder currentSortOrder = SortOrder.ascending;

  // ProductListProvider() {
  //   filteredProducts = products;
  //   log('message');
  // }

  Future<void> getAllProducts() async {
    isLoading = true;
    notifyListeners();
    products = [];
    final response = await getAll.getProducts();
    response.fold(
      (l) => {
        isError = true,
        notifyListeners(),
      },
      (r) => {
        products = r,
        filteredProducts = products,
        notifyListeners(),
      },
    );
    isLoading = false;
    notifyListeners();
  }

  void filterProducts(String query) async {
    // await getAllProducts();
    filteredProducts = products
        .where((product) =>
            product.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void sortProducts(SortOrder sortOrder) {
    currentSortOrder = sortOrder;
    if (currentSortOrder == SortOrder.ascending) {
      filteredProducts.sort((a, b) => a.title!.compareTo(b.title!));
      log(filteredProducts.toString());
    } else {
      filteredProducts.sort((a, b) => b.title!.compareTo(a.title!));
    }
    notifyListeners();
  }
}
