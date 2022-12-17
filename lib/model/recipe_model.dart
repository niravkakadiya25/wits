import 'package:wit/model/ingredients.dart';
import 'package:wit/model/steps.dart';

class RecipeModel {
  List<StepModel>? steps=[];
  List<Ingredients>? ingredients=[];
  dynamic recipePhoto;
  dynamic recipeName;
  dynamic serves;
  dynamic prepTime;
  dynamic cookTime;

  RecipeModel(
      {this.steps,
      this.ingredients,
      this.recipePhoto,
      this.recipeName,
      this.serves,
      this.prepTime,
      this.cookTime});

  RecipeModel.fromJson(dynamic json) {
    recipePhoto = json['recipePhoto'];
    serves = json['serves'];
    prepTime = json['prepTime'];
    cookTime = json['cookTime'];
    recipeName = json['recipeName'];
    recipeName = json['recipeName'];
    if (json['steps'] != null) {
      steps?.clear();
      json['steps'].forEach((v) {
        steps?.add(StepModel.fromJson(v));
      });
    }
    if (json['ingredients'] != null) {
      ingredients?.clear();
      json['ingredients'].forEach((v) {
        ingredients?.add(Ingredients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recipePhoto'] = recipePhoto;
    map['recipeName'] = recipeName;
    map['serves'] = serves;
    map['cookTime'] = cookTime;
    map['prepTime'] = prepTime;
    map['steps'] = steps?.map((v) => v.toJson()).toList();
    map['ingredients'] = ingredients?.map((v) => v.toJson()).toList();
    return map;
  }
}
