import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wit/model/ingredients.dart';
import 'package:wit/model/steps.dart';

class ReceiptProvider extends ChangeNotifier {
  dynamic receiptPhoto;
  dynamic receiptName;
  dynamic serves;
  dynamic prepTime;
  dynamic cookTime;
  List<Ingredients> ingredientsList = [];
  List<StepModel> stepsList = [];
  File? pickedFile;

}
