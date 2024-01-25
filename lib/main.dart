import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import "package:image_picker_platform_interface/src/types/image_source.dart";


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImagePickerApp(),
    );
  }
}



class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({super.key});

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;

  /*
Future getImage(ImageSource source) async {
  
  final image = await ImagePicker().pickImage(source:ImageSource.camera);
  if (image == null) return;

  final imageTemporaryawait saveFilePermenently(image.path);

 setState(() {
    _image= imageTemporary;
  });
  */
  Future getImage(ImageSource sourcefromuser) async {
    try{
  final image = await ImagePicker().pickImage(source:sourcefromuser);
  if (image == null) return;


  //final imageTemporary=File(image.path);
  final imagePermanent=await saveFilePermenently(image.path);

  setState(() {
    _image= imagePermanent;
  });
    } 
    on PlatformException catch (e){
      print("failed to pick image:$e");
    }
  }




    Future<File> saveFilePermenently(String imagePath) async {
      final directory = await getApplicationDocumentsDirectory();
      final name= basename(imagePath);
      final image= File("${directory.path}/$name");

      return File(imagePath).copy(image.path);
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title:const Text("pick an image"),
    ),
    body: Center(
      child: Column(
        children: [
        const SizedBox(
          height: 40,),
          _image !=null
          ? Image.file(
            _image!,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          )
        : Image.network("https://cdn.shoplightspeed.com/shops/634895/files/39359311/1600x2048x2/taylor-swift-red-taylors-version-4lp.jpg", ),
        const SizedBox(height: 40,),
        CustomButton(
          title: "pick from gallery", 
          icon: Icons.image_outlined,
          onClick: () =>getImage(ImageSource.gallery),
        ),
           CustomButton(
          title: "pick from camera", 
          icon: Icons.camera,
          onClick: () => getImage(ImageSource.camera)
          
          ),
          
      ],
      )
      ),
    );
  }
}


Widget CustomButton({
 required String title,
 required IconData icon,
 required VoidCallback onClick,
}){
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child:  Row(
        children: [
          Icon(icon),
          const SizedBox(width: 20,),
          Text(title)
        ],
      )),
  );
}

void main() {
  runApp(const MyApp());
}
