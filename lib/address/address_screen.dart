import 'package:flutter/material.dart';

import '../main.dart';
import 'address_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final titleEditingController = TextEditingController();
  final commentEditingController = TextEditingController();

  Dismissible Function(BuildContext, int) _itemBuilder(
          List<AddressModel> notes) =>
      (BuildContext context, int index) {
        final item = notes[index];

        return Dismissible(
          key: ValueKey(notes[index]),
          background: Container(
            padding: const EdgeInsets.only(left: 16),
            color: Colors.green,
            child: const Align(
                alignment: Alignment.centerLeft, child: Icon(Icons.edit)),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red,
            child: const Align(
                alignment: Alignment.centerRight, child: Icon(Icons.close)),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              _confirmDelete(item.id);
            } else if (direction == DismissDirection.startToEnd) {
              _showAlert(true, item);
            }
            return null;
          },
          child: ListTile(
            leading: const Icon(Icons.notes_sharp),
            title: Text(item.title,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            trailing: Text(
                '${item.dateFormat.toString()}, ${item.timeFormat.toString()}'),
            subtitle: Text(item.comment,
                maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
        );
      };

  void _addNote() {
    if (titleEditingController.text.isEmpty &&
        commentEditingController.text.isEmpty) return;

    final data = AddressModel(
        title: titleEditingController.text,
        comment: commentEditingController.text,
        date: DateTime.now());

    objectBox.addNotes(data);
    Navigator.pop(context);
  }

  Future<void> _editNote(AddressModel item) async {
    if (titleEditingController.text.isEmpty &&
        commentEditingController.text.isEmpty) return;

    final data = AddressModel(
        id: item.id,
        title: titleEditingController.text,
        comment: commentEditingController.text,
        date: DateTime.now());

    objectBox.addNotes(data);
    Navigator.pop(context);
  }

  Future<void> _confirmDelete(int id) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  objectBox.removeNote(id);
                  Navigator.pop(context);
                },
                child: const Text("Delete")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black54)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlert(bool isEdit, item) async {
    if (isEdit) {
      final AddressModel noteDate = item;

      titleEditingController.text = noteDate.title;
      commentEditingController.text = noteDate.comment;
    } else {
      titleEditingController.text = '';
      commentEditingController.text = '';
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit' : 'Add'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleEditingController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: commentEditingController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Full Address'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Colors.black54)),
              ),
              TextButton(
                onPressed: () => isEdit ? _editNote(item) : _addNote(),
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Address'),
      ),
      body: StreamBuilder<List<AddressModel>>(
        stream: objectBox.getNotes(),
        builder: (context, snapShot) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapShot.hasData ? snapShot.data!.length : 0,
              itemBuilder: _itemBuilder(snapShot.data ?? []));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAlert(false, []),
        child: const Icon(Icons.add),
      ),
    );
  }
}
