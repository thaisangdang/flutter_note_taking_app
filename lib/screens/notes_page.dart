import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Reference the box we opened in main.dart
  final _myBox = Hive.box('note_database');
  final _textController = TextEditingController();

  // FUNCTION: Write Data
  void writeData() {
    if (_textController.text.isNotEmpty) {
      // .add() automatically generates a unique key
      _myBox.add(_textController.text);
      _textController.clear();
      Navigator.pop(context);
    }
  }

  // FUNCTION: Delete Data
  void deleteData(int index) {
    _myBox.deleteAt(index);
  }

  // FUNCTION: Show Input Dialog
  void showNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "What's on your mind?"),
            maxLines: 4, // Allow multi-line input
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: writeData, child: const Text('Save')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('Sticky Notes'),
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNoteDialog,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      // THE MAGIC WIDGET: Listens to database changes
      body: ValueListenableBuilder(
        valueListenable: _myBox.listenable(),
        builder: (context, box, widget) {
          if (box.isEmpty) {
            return const Center(child: Text('No notes yet!'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 Notes per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: box.length,
            itemBuilder: (context, index) {
              // Read data at index
              final noteText = box.getAt(index);

              return GestureDetector(
                onLongPress: () => deleteData(index),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Delete Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => deleteData(index),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red[300],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Note Content
                      Expanded(
                        child: Text(
                          noteText.toString(),
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
