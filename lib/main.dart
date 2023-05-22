import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'AllPersonData.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController namecontroller = TextEditingController();

  Future ChoiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path.toString());
    });
  }

  Future UploadImage() async {
    final uri =
        Uri.parse("http://192.168.1.24/image_upload_php_mysql/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = namecontroller.text;
    var pic = await http.MultipartFile.fromPath("image", _image!.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Image Uploaded");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UploadImage().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MySQL Image Upload"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(labelText: "Name"),
              ),
            ),
            IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  ChoiceImage();
                }),
            Container(
              child: _image == null
                  ? Text("No image Selected")
                  : Image.file(_image!),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
                child: Text("Upload Image"),
                onPressed: () {
                  UploadImage();
                  Future.delayed(Duration(milliseconds: 100), () {
                    // Do something
                  });
                  Future.delayed(Duration(milliseconds: 2000), () {
                    // Do something
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllPersonData()));
                  });
                })
          ],
        ),
      ),
    );
  }
}
