//import 'dart:io';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:workmanager/workmanager.dart';
//import 'package:flutter_uploader/flutter_uploader.dart';

bool isUploding = false;

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     // if (isUploding) {
//     print('Background Check!!!!!!!!!!!!!!!!!!!!!!!');
//     //}
//     return Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

bool uploaded = false;

class _MyAppState extends State<MyApp> {
  // FilePickerResult? result;
  PlatformFile? pickedfile;
  UploadTask? uploadTask;

  Future _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedfile = result.files.first;
    });
  }

  Future _uploadFile() async {
    setState(() {
      uploaded = false;
    });
    final path = 'files/${pickedfile!.name}';
    final file = File(pickedfile!.path!);

    // ignore: unnecessary_null_comparison
    if (file == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDir = referenceRoot.child(path);
    try {
      setState(() {
        uploadTask = referenceDir.putFile(file);
      });
      final snapshot = await uploadTask!.whenComplete(() {
        setState(() {
          uploaded = true;
        });
      });
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download link: $urlDownload');
      setState(() {
        uploadTask = null;
      });
    } catch (e) {
      print('Firebase error: $e');
    }
    // Firebase.initializeApp();
    // final ref = FirebaseStorage.instance.ref().child(path);
    // uploadTask = ref.putFile(file);

    // final snapshot = await uploadTask!.whenComplete(() {});
    // final urlDownload = await snapshot.ref.getDownloadURL();
    // print('Download link: $urlDownload');
  }

  // Future<void> _filepicker() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     // File file = File(result.files.single.path);
  //     PlatformFile file = result.files.first;

  //     print(file.name);
  //     print(file.bytes);
  //     print(file.size);
  //     print(file.extension);
  //     print(file.path);
  //   } else {
  //     print("No file selected");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (pickedfile != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected file:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(pickedfile?.name ?? '',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            child: Icon(Icons.close),
                            onTap: () {
                              setState(() {
                                pickedfile = null;
                                uploaded = false;
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ElevatedButton(
                  onPressed: () {
                    _pickFile();
                    // result =
                    //     await FilePicker.platform.pickFiles(allowMultiple: true);
                    // if (result == null) {
                    //   print("No file selected");
                    // } else {
                    //   setState(() {});
                    //   result?.files.forEach((element) {
                    //     print(element.name);
                    //   });
                    // }
                  },
                  child: Text('Select flie')),
              ElevatedButton(
                  onPressed: () {
                    if (pickedfile != null) {
                      _uploadFile();
                      FlutterBackgroundService().invoke('setAsBackground');
                    } else {
                      var snackBar = SnackBar(
                        content: Text('File not selected'),
                        action: SnackBarAction(
                          label: 'Hide',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('Upload flie')),
              if (uploadTask?.snapshotEvents != null) buildProgress(),
              if (uploaded)
                Row(
                  children: [
                    Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Uploaded Successfully',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
    // Widget buildProgress() =>
    //     StreamBuilder<TaskSnapshot>(builder: (context, snapshot) {});
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                color: Colors.green,
              ),
              Center(
                child: Text(
                  '${(100 * progress).roundToDouble()}%',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]),
          );
        } else {
          return SizedBox();
        }
      });
}
