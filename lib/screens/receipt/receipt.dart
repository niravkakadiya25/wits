import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wit/controller/providers/ReceiptProvider.dart';
import 'package:wit/screens/receipt/ingredients.dart';

class ReceiptScreen extends StatefulWidget {
  final bool isFromHome;

  const ReceiptScreen({Key? key, this.isFromHome = false}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  var persons = [
    'person(s)',
  ];
  String dropdownvalue = 'person(s)';
  DateTime _prepDateTime = DateTime.now();
  DateTime _cookTime = DateTime.now();

  TextEditingController receiptName = TextEditingController();
  TextEditingController personController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  late ReceiptProvider receiptProvider;

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: const Text("Fræom where do you want to take the photo?"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: const Text("Gallery"),
                        onTap: () {
                          Navigator.of(context).pop(false);
                          getImageByGallary();
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: const Text("Camera"),
                        onTap: () {
                          Navigator.of(context).pop(false);
                          getImage();
                        },
                      )
                    ],
                  ),
                ),
              )
            : CupertinoAlertDialog(
                title: const Text("From where do you want to take the photo?"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: const Text("Gallery"),
                        onTap: () {
                          Navigator.of(context).pop(false);
                          getImageByGallary();
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: const Text("Camera"),
                        onTap: () {
                          Navigator.of(context).pop(false);
                          getImage();
                        },
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 350,
        maxHeight: 350);

    if (pickedFile != null) {
      receiptProvider.pickedFile = File(pickedFile.path);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  Future getImageByGallary() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 350,
        maxHeight: 350);

    if (pickedFile != null) {
      receiptProvider.pickedFile = File(pickedFile.path);

      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    receiptProvider = Provider.of<ReceiptProvider>(context, listen: true);

    return Scaffold(
      floatingActionButton: widget.isFromHome
          ? null
          : FloatingActionButton(
              onPressed: () {
                ReceiptProvider receiptProvider =
                    Provider.of<ReceiptProvider>(context, listen: false);

                receiptProvider.receiptPhoto = '';
                receiptProvider.receiptName =
                    receiptName.text.trim().toString();
                receiptProvider.serves =
                    personController.text.trim().toString();
                receiptProvider.prepTime =
                    '${_prepDateTime.hour.toString().padLeft(2, '0')}:${_prepDateTime.minute.toString().padLeft(2, '0')}:${_prepDateTime.second.toString().padLeft(2, '0')}';
                receiptProvider.cookTime =
                    '${_cookTime.hour.toString().padLeft(2, '0')}:${_cookTime.minute.toString().padLeft(2, '0')}:${_cookTime.second.toString().padLeft(2, '0')}';

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IngredientsScreen(),
                    ));
              },
              child: const Icon(Icons.arrow_forward),
            ),
      appBar: widget.isFromHome
          ? null
          : AppBar(
              title: const Text('Create Receipt'),
            ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: 100,
                  width: 100,
                  child: receiptProvider.receiptPhoto.toString().isNotEmpty
                      ? Image.network(receiptProvider.receiptPhoto)
                      : receiptProvider.pickedFile == null
                          ? const Icon(Icons.camera_alt)
                          : Image.file(
                              File(receiptProvider.pickedFile?.path ?? '')),
                ),
                onTap: () async {
                  _showSelectionDialog(context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: widget.isFromHome,
                controller: widget.isFromHome ? null : receiptName,
                initialValue: receiptProvider.receiptName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                validator: (value) {
                  return null;
                },
                decoration: inputDecoration(
                  hintText: 'Receipt name',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Serves'),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: widget.isFromHome,
                      controller: widget.isFromHome ? null : personController,
                      initialValue: receiptProvider.serves,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      validator: (value) {
                        return null;
                      },
                      decoration: inputDecoration(
                        hintText: 'Ex 2',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: DropdownButton(
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: persons.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Prep time'),
                        InkWell(
                          onTap: () {
                            if (!widget.isFromHome) {
                              if (Platform.isAndroid) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 220,
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      padding: const EdgeInsets.only(top: 8.0),
                                      color: Colors.white,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _prepDateTime,
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        // This is called when the user changes the time.
                                        onDateTimeChanged: (DateTime newTime) {
                                          setState(
                                              () => _prepDateTime = newTime);
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 220,
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        color: Colors.white,
                                        child: CupertinoDatePicker(
                                          initialDateTime: _prepDateTime,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(
                                                () => _prepDateTime = newTime);
                                          },
                                        ),
                                      );
                                    });
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              widget.isFromHome
                                  ? receiptProvider.prepTime.toString()
                                  : '${_prepDateTime.hour.toString().padLeft(2, '0')}:${_prepDateTime.minute.toString().padLeft(2, '0')}:${_prepDateTime.second.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cook time'),
                        InkWell(
                          onTap: () {
                            if (!widget.isFromHome) {
                              if (Platform.isAndroid) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 220,
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      padding: const EdgeInsets.only(top: 8.0),
                                      color: Colors.white,
                                      child: CupertinoDatePicker(
                                        initialDateTime: _cookTime,
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        // This is called when the user changes the time.
                                        onDateTimeChanged: (DateTime newTime) {
                                          setState(() => _cookTime = newTime);
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 220,
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        color: Colors.white,
                                        child: CupertinoDatePicker(
                                          initialDateTime: _cookTime,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: true,
                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => _cookTime = newTime);
                                          },
                                        ),
                                      );
                                    });
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              widget.isFromHome
                                  ? receiptProvider.cookTime.toString()
                                  : '${_cookTime.hour.toString().padLeft(2, '0')}:${_cookTime.minute.toString().padLeft(2, '0')}:${_cookTime.second.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

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
