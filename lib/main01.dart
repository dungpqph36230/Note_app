import 'package:flutter/material.dart';

void main() {
  runApp(NotesApp());
}

class Note {
  String text;

  Note({
    required this.text,
  });
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final List<Note> _notes = [];

  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newNoteText = '';

        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            onChanged: (value) {
              newNoteText = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _notes.add(Note(
                    text: newNoteText,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editNote(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedNoteText = _notes[index].text;

        return AlertDialog(
          title: Text('Edit Note'),
          content: TextField(
            onChanged: (value) {
              updatedNoteText = value;
            },
            controller: TextEditingController(text: _notes[index].text),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _notes[index].text = updatedNoteText;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_notes[index].text),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editNote(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteNote(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
} 
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:audioplayers/audioplayers.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image and Audio Upload',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   File? _imageFile;
//   String? _audioFilePath;
//   bool _isRecording = false;
//   late AudioPlayer _audioPlayer;

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedImage = await ImagePicker().pickImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _pickAudio() async {
//     final pickedAudio = await ImagePicker().pickMedia();
//     if (pickedAudio != null) {
//       setState(() {
//         _audioFilePath = pickedAudio.path;
//       });
//     }
//   }

//   void _toggleRecording() async {
//     if (_isRecording) {
//       await _audioPlayer.stop();
//     } else {
//       await _audioPlayer.play(UrlSource(_audioFilePath ?? ''));
//     }
//     setState(() {
//       _isRecording = !_isRecording;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image and Audio Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               child: Text('Choose Image'),
//             ),
//             SizedBox(height: 16.0),
//             if (_imageFile != null) Image.file(_imageFile!),
//             SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: _pickAudio,
//               child: Text('Choose Audio'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _toggleRecording,
//               child: Text(
//                 _isRecording ? 'Stop Recording' : 'Start Recording',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Flexible( // Sử dụng Flexible để cho phép xuống dòng tự động
//               child: TextField(
//                 onChanged: onUpdateNoteText,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your note...',
//                 ),
//                 maxLines: null, // Cho phép xuống dòng tự động
//                 textInputAction: TextInputAction.newline, // Hiển thị nút Enter để xuống dòng
//               ),
//             ),
