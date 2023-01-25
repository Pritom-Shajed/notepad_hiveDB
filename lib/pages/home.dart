import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notepad_hive/constants/constants.dart';
import 'package:notepad_hive/widgets/customButton.dart';
import 'package:notepad_hive/widgets/dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _addController = TextEditingController();
  TextEditingController _updateController = TextEditingController();
  Box? notepad;

  editDialog(index) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'EDIT NOTE',
                      style: mediumText,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _updateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(width: 3),
                        ),
                        prefixIcon: Icon(Icons.menu_book_outlined),
                        hintText: 'Edit your note',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    customButton(
                      onClick: () {
                        final updatedNote = _updateController.text;
                        if (updatedNote.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return alert(
                                    title:
                                        'Note is updating into an empty note! Proceed?',
                                    onClickYes: () {
                                      try {
                                        notepad!.putAt(index, updatedNote);
                                        _updateController.clear();
                                        Navigator.pop(context);
                                        EasyLoading.showSuccess('Updated');
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: e.toString());
                                      }
                                    },
                                    onClickNo: () => Navigator.pop(context));
                              });
                        } else {
                          try {
                            notepad!.putAt(index, updatedNote);
                            _updateController.clear();
                            Navigator.pop(context);
                            EasyLoading.showSuccess('Updated');
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        }
                      },
                      title: 'Update',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    notepad = Hive.box('notepad');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          showDialog(
              context: context,
              builder: (_) {
                return alert(
                    title: 'Are you sure to exit?',
                    onClickYes: () => SystemNavigator.pop(),
                    onClickNo: () => Navigator.pop(context));
              });
          return Future.value(false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextField(
                  controller: _addController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.menu_book_outlined),
                    label: Text('ADD NOTE'),
                    hintText: 'write your note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 3),
                    ),
                  ),
                ),
              ),
              customButton(
                onClick: () {
                  final addedNote = _addController.text;
                  if (addedNote.isEmpty) {
                    Fluttertoast.showToast(msg: 'Notes can\'t be empty');
                  } else {
                    try {
                      notepad!.add(addedNote);
                      _addController.clear();
                      EasyLoading.showSuccess('Added');
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  }
                },
                title: 'ADD',
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('notepad').listenable(),
                  builder: (context, box, Widget) {
                    return ListView.builder(
                      itemCount: notepad!.keys.toList().length,
                      itemBuilder: (_, index) {
                        return Card(
                          child: ListTile(
                              title: Text(notepad!.getAt(index)),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'key_edit') {
                                    editDialog(index);
                                  } else if (value == 'key_delete') {
                                    notepad!.deleteAt(index);
                                    Fluttertoast.showToast(msg: 'Deleted');
                                  }
                                },
                                child: Icon(Icons.more_vert),
                                itemBuilder: (context) {
                                  return <PopupMenuEntry<String>>[
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text('Edit'),
                                        leading: Icon(Icons.edit),
                                      ),
                                      value: 'key_edit',
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text('Delete'),
                                        leading: Icon(Icons.delete),
                                      ),
                                      value: 'key_delete',
                                    ),
                                  ];
                                },
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
