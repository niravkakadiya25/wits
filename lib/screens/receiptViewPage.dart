import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wit/controller/providers/ReceiptProvider.dart';
import 'package:wit/model/recipe_model.dart';
import 'package:wit/screens/receipt/addition_screen.dart';
import 'package:wit/screens/receipt/ingredients.dart';
import 'package:wit/screens/receipt/receipt.dart';

class ReciptInTab extends StatefulWidget {
  final RecipeModel recipeModel;

  const ReciptInTab({Key? key, required this.recipeModel}) : super(key: key);

  @override
  State<ReciptInTab> createState() => _ReciptInTabState();
}

class _ReciptInTabState extends State<ReciptInTab> {
  @override
  void initState() {
    ReceiptProvider _receiptProvider =
        Provider.of<ReceiptProvider>(context, listen: false);
    // TODO: implement initState
    _receiptProvider.stepsList = widget.recipeModel.steps ?? [];
    _receiptProvider.receiptPhoto = widget.recipeModel.recipePhoto;
    _receiptProvider.receiptName = widget.recipeModel.recipeName;
    _receiptProvider.serves = widget.recipeModel.serves;
    _receiptProvider.prepTime = widget.recipeModel.prepTime;
    _receiptProvider.cookTime = widget.recipeModel.cookTime;
    _receiptProvider.ingredientsList = widget.recipeModel.ingredients ?? [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider _receiptProvider =
    Provider.of<ReceiptProvider>(context, listen: true);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recipe'),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Recipe')),
              Tab(child: Text('ingredients')),
              Tab(child: Text('Steps')),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            const ReceiptScreen(isFromHome: true),
            IngredientsScreen(isFromHome: true,ingredients: _receiptProvider.ingredientsList),
            AdditionalScreen(isFromHome: true,steps: _receiptProvider.stepsList),
          ],
        ),
      ),
    );
  }
}
