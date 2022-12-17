import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wit/model/recipe_model.dart';
import 'package:wit/screens/receipt/addition_screen.dart';
import 'package:wit/screens/receipt/ingredients.dart';
import 'package:wit/screens/receipt/receipt.dart';
import 'package:wit/screens/receiptViewPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReceiptScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recipe')
            .where('id',
                isEqualTo: (FirebaseAuth.instance.currentUser?.uid ?? ''))
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.docs.isNotEmpty ?? false) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  RecipeModel recipeModel = RecipeModel.fromJson(
                      (snapshot.data?.docs[index].data() as Map)['recipeData']);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReciptInTab(recipeModel: recipeModel),
                          ));
                    },
                    child: ListTile(
                      title: Text(recipeModel.recipeName ?? ''),
                      subtitle: Text(recipeModel.recipeName ?? ''),
                    ),
                  );
                },
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
