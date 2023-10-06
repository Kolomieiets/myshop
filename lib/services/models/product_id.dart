class ProductId {
  final String name;

  ProductId(this.name);

  factory ProductId.fromJson(Map<String, dynamic> json) {
    String name = json['name']!;
    return ProductId(name);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'name': name};
    return json;
  }
}
