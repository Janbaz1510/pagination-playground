class HomeModel {
  final List<Product> product;
  final int totalItems;

  HomeModel( {required this.product, required this.totalItems,});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final list = json['hits'] as List<dynamic>;
    final products = list.map((item) => Product.fromJson(item)).toList();
    final total = json['nbHits'] ?? 0;
    return HomeModel(product: products, totalItems: total);
  }
}

class Product {
  final String name;

  Product({required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(name: json['name'] ?? '');
  }
}
