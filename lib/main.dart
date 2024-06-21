import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(NoteApp());
}

class Note {
  String text;
  List<File> images;
  List<File> videos;

  Note({
    required this.text,
    required this.images,
    required this.videos,
  });
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteScreen(),
    );
  }
}

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Note> notes = [];

  void _chooseImage(int noteIndex) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        notes[noteIndex].images.add(imageFile);
      }
    });
  }

  void _chooseVideo(int noteIndex) async {
    final pickedFile =
        await ImagePicker().getVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        File videoFile = File(pickedFile.path);
        notes[noteIndex].videos.add(videoFile);
      }
    });
  }

  void _deleteImage(int noteIndex, int imageIndex) {
    setState(() {
      File imageFile = notes[noteIndex].images[imageIndex];
      imageFile.deleteSync(); // Xóa file ảnh từ thiết bị
      notes[noteIndex].images.removeAt(imageIndex);
    });
  }

  void _deleteVideo(int noteIndex, int videoIndex) {
    setState(() {
      File videoFile = notes[noteIndex].videos[videoIndex];
      videoFile.deleteSync(); // Xóa file video từ thiết bị
      notes[noteIndex].videos.removeAt(videoIndex);
    });
  }

  void _updateNoteText(int noteIndex, String newText) {
    setState(() {
      notes[noteIndex].text = newText;
    });
  }

  void _clearNoteText(int noteIndex) {
    setState(() {
      notes[noteIndex].text = '';
    });
  }

  void _addNote() {
    setState(() {
      notes.add(Note(
        text: '',
        images: [],
        videos: [],
      ));
    });
  }

  void _deleteNote(int noteIndex) {
    setState(() {
      Note note = notes[noteIndex];  
      for (var image in note.images) {
        image.deleteSync(); // Xóa tất cả các file ảnh từ thiết bị
      }
      for (var video in note.videos) {
        video.deleteSync(); // Xóa tất cảcác file video từ thiết bị
      }
      notes.removeAt(noteIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteCard(
            note: notes[index],
            index: index,
            onChooseImage: _chooseImage,
            onChooseVideo: _chooseVideo,
            onDeleteImage: _deleteImage,
            onDeleteVideo: _deleteVideo,
            onUpdateNoteText: _updateNoteText,
            onClearNoteText: _clearNoteText,
            onDeleteNote: _deleteNote,
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

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final Function(int) onChooseImage;
  final Function(int) onChooseVideo;
  final Function(int, int) onDeleteImage;
  final Function(int, int) onDeleteVideo;
  final Function(int, String) onUpdateNoteText;
  final Function(int) onClearNoteText;
  final Function(int) onDeleteNote;

  NoteCard({
    required this.note,
    required this.index,
    required this.onChooseImage,
    required this.onChooseVideo,
    required this.onDeleteImage,
    required this.onDeleteVideo,
    required this.onUpdateNoteText,
    required this.onClearNoteText,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => onUpdateNoteText(index, value),
              decoration: InputDecoration(
                hintText: 'Enter note text...',
              ),
            ),
          ),
          if (note.images.isNotEmpty)
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: note.images.length,
                itemBuilder: (context, imageIndex) {
                  return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ImageDialog(
                                    imageFile: note.images[imageIndex]);
                              },
                            );
                          },
                          child: Hero(
                            tag: 'image_' + imageIndex.toString(),
                            child: Image.file(
                              note.images[imageIndex],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => onDeleteImage(index, imageIndex),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (note.videos.isNotEmpty)
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: 200, // Thay đổi tỷ lệ phần trăm tùy ý
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: note.videos.length,
                itemBuilder: (context, videoIndex) {
                  return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return VideoPlayerDialog(
                                    file: note.videos[videoIndex]);
                              },
                            );
                          },
                          child: Hero(
                            tag: 'video_' + videoIndex.toString(),
                            child: VideoPlayerWidget(
                                file: note.videos[videoIndex]),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => onDeleteVideo(index, videoIndex),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => onChooseImage(index),
                child: Text('Add Image'),
              ),
              ElevatedButton(
                onPressed: () => onChooseVideo(index),
                child: Text('Add Video'),
              ),
              ElevatedButton(
                onPressed: () => onDeleteNote(index),
                child: Text('Delete Note'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final File imageFile;

  ImageDialog({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        child: Image.file(imageFile),
      ),
    );
  }
}

class VideoPlayerDialog extends StatelessWidget {
  final File file;

  VideoPlayerDialog({required this.file});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        child: VideoPlayerWidget(file: file),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File file;

  VideoPlayerWidget({required this.file});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    _controller.initialize().then((_) {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else {
      return Container();
    }
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen(this.videoPath);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Video Player'),
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
