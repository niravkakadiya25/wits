import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wit/controller/providers/ReceiptProvider.dart';
import 'package:wit/model/ingredients.dart';
import 'package:wit/screens/receipt/addition_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final bool isFromHome;
  final List<Ingredients> ingredients;

  const IngredientsScreen(
      {Key? key, this.isFromHome = false, this.ingredients = const []})
      : super(key: key);

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  List<Ingredients> ingredients = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromHome) {
      ingredients = widget.ingredients;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromHome
          ? null
          : AppBar(
              title: const Text('Add Ingredients'),
              actions: [
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward),
                  ),
                  onTap: () {
                    ReceiptProvider receiptProvider =
                        Provider.of<ReceiptProvider>(context, listen: false);

                    receiptProvider.ingredientsList = ingredients;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdditionalScreen(),
                        ));
                  },
                )
              ],
            ),
      floatingActionButton: widget.isFromHome
          ? null
          : FloatingActionButton(
              onPressed: () async {
                TextEditingController nameController = TextEditingController();
                TextEditingController quantityController =
                    TextEditingController();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Ingredients'),
                      content: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: nameController,
                              style: textStyle,
                              decoration: inputDecoration(hintText: 'name'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: quantityController,
                              style: textStyle,
                              decoration: inputDecoration(hintText: 'quantity'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () {
                            ingredients.add(Ingredients(
                                name: nameController.text.trim(),
                                quantity: quantityController.text.trim()));
                            nameController.clear();
                            quantityController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                );
                setState(() {});
              },
              child: const Icon(Icons.add),
            ),
      body: SingleChildScrollView(
        child: ReorderableListView.builder(
          dragStartBehavior: DragStartBehavior.down,
          key: UniqueKey(),
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (int oldIndex, int newIndex) {
            if(widget.isFromHome) return;
            if (newIndex > ingredients.length) return;
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = ingredients.removeAt(oldIndex);
            ingredients.insert(newIndex, item);
            setState(() {});
          },
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            return Container(
              key: ValueKey(index),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text("${ingredients[index].name}"),
                subtitle: Text(ingredients[index].quantity),
                tileColor: Colors.grey,
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.menu),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 15,
  );

  InputDecoration inputDecoration({required String hintText}) {
    return InputDecoration(
      fillColor: Colors.white,
      hoverColor: Colors.white,
      focusColor: Colors.white,
      filled: true,
      errorStyle: const TextStyle(
        color: Colors.white,
      ),
      hintText: hintText,
      hintStyle: textStyle,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    );
  }
}
