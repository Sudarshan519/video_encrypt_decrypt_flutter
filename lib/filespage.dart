import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:open_file/open_file.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  late String directory;
  String maindir = "प्रारम्भिक कक्षा पढाइ";
  List<io.FileSystemEntity> file = [];
  void _listofFiles() async {
    directory = (await getExternalStorageDirectory())!.path;
    setState(() {
      file = io.Directory("$directory/")
          .listSync(); //use your folder name insted of resume.
    });
    print("files lenght" + file.length.toString());
  }

  @override
  void initState() {
    _listofFiles();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(maindir)),
      body: file.isEmpty
          ? const Center(child: Text("Folder Empty"))
          : ListView.builder(
              itemBuilder: (_, int i) {
                return ListTile(
                    onTap: () async {
                      var isfile = await io.File(file[i].path).exists();
                      print(isfile);
                      if (isfile) {
                        OpenFile.open(file[i].path);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SubDirPage(title: file[i].path)));
                      }
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (_) => SubDirPage(title: file[i].path)));
                    },
                    // leading: const Icon(Icons.folder),
                    title: Text(file[i].path.split('/').last.toString()));
              },
              itemCount: file.length,
            ),
    );
  }
}

class SubDirPage extends StatefulWidget {
  const SubDirPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SubDirPage> createState() => _SubDirPageState();
}

class _SubDirPageState extends State<SubDirPage> {
  var file = <io.FileSystemEntity>[];
  void _listofFiles() async {
    // directory = (await getExternalStorageDirectory())!.path;

    file = io.Directory(widget.title)
        .listSync(); //use your folder name insted of resume.

    print("files lenght" + file.length.toString());
    setState(() {});
  }

  @override
  void initState() {
    _listofFiles();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.split('/').last),
      ),
      body: file.isEmpty
          ? const Center(child: Text("Folder Empty"))
          : ListView.builder(
              itemCount: file.length,
              itemBuilder: (_, int i) {
                return ListTile(
                    onTap: () async {
                      var isfile = await io.File(file[i].path).exists();
                      print(isfile);
                      if (isfile) {
                        OpenFile.open(file[i].path);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SubDirPage(title: file[i].path)));
                      }
                    },
                    // leading: const Icon(Icons.folder),
                    title: Text(file[i].path.split('/').last.toString()));
              }),
    );
  }
}
