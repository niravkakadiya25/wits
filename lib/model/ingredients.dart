class Ingredients{
  dynamic name;
  dynamic quantity;

  Ingredients({this.name, this.quantity});
  Ingredients.fromJson(dynamic json) {
    name = json['name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['quantity'] = quantity;
    return map;
  }
}