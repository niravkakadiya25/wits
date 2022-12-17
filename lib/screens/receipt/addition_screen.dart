import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wit/controller/auth_controller.dart';
import 'package:wit/controller/providers/ReceiptProvider.dart';
import 'package:wit/model/UserAuthInfo.dart';
import 'package:wit/model/recipe_model.dart';
import 'package:wit/model/steps.dart';
import 'package:wit/screens/home_screen.dart';

class AdditionalScreen extends StatefulWidget {
  final bool isFromHome;
  final List<StepModel> steps;

  const AdditionalScreen(
      {Key? key, this.isFromHome = false, this.steps = const []})
      : super(key: key);

  @override
  State<AdditionalScreen> createState() => _AdditionalScreenState();
}

class _AdditionalScreenState extends State<AdditionalScreen> {
  List<StepModel> steps = [];

  Future<String> uploadImage(File? image) async {
    if (image != null) {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('upload/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } else {
      return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromHome) {
      steps = widget.steps;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromHome
          ? null
          : AppBar(
              title: const Text('Add Steps'),
              actions: [
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.done),
                  ),
                  onTap: () async {
                    ReceiptProvider receiptProvider =
                        Provider.of<ReceiptProvider>(context, listen: false);

                    receiptProvider.stepsList = steps;
                   receiptProvider.receiptPhoto = await uploadImage(receiptProvider.pickedFile);
                    UserAuthInfo? userAuthInfo =
                        await AuthController().getUserAuthInfo();

                    String recipeId = const Uuid().v4();

                    RecipeModel recipeModel = RecipeModel(
                        cookTime: receiptProvider.cookTime,
                        ingredients: receiptProvider.ingredientsList,
                        prepTime: receiptProvider.prepTime,
                        recipeName: receiptProvider.receiptName,
                        recipePhoto: receiptProvider.receiptPhoto,
                        serves: receiptProvider.serves,
                        steps: receiptProvider.stepsList);

                    await FirebaseFirestore.instance.collection('recipe').add({
                      'id': userAuthInfo?.fireBaseUserId ?? '',
                      'recipeId': recipeId,
                      'recipeData': recipeModel.toJson()
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false);
                  },
                )
              ],
            ),
      floatingActionButton: widget.isFromHome
          ? null
          : FloatingActionButton(
              onPressed: () async {
                TextEditingController nameController = TextEditingController();
                TextEditingController instructionController =
                    TextEditingController();
                TextEditingController personalTouchController =
                    TextEditingController();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Ingredients'),
                      content: SingleChildScrollView(
                        child: Container(
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
                                decoration:
                                    inputDecoration(hintText: 'Steps name'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: instructionController,
                                style: textStyle,
                                decoration:
                                    inputDecoration(hintText: 'instruction'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: personalTouchController,
                                style: textStyle,
                                decoration:
                                    inputDecoration(hintText: 'personal Touch'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () {
                            steps.add(StepModel(
                                instruction: instructionController.text.trim(),
                                personalTouch:
                                    personalTouchController.text.trim(),
                                stepName: nameController.text.trim(),
                                photo: ''));
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
            if (widget.isFromHome) return;
            if (newIndex > steps.length) return;
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = steps.removeAt(oldIndex);
            steps.insert(newIndex, item);
            setState(() {});
          },
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return Container(
              key: ValueKey(index),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text("${steps[index].stepName}"),
                subtitle: Text(steps[index].instruction),
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
      hintStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
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
