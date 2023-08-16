
import 'dart:io';

import 'package:app_chat/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';



class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
    
     File? imageFile;
    TextEditingController fullNameController = TextEditingController();

    void selectImage(ImageSource source)async{
      XFile? pickedFile = await ImagePicker().pickImage(source: source);

      if(pickedFile!= null){
        cropImage(pickedFile);
      }
    }

    void cropImage(XFile file)async{
     CroppedFile? croppedImage =  await ImageCropper().cropImage(sourcePath: file.path,
     aspectRatio: CropAspectRatio(ratioX: 1, ratioY:1),
     compressQuality: 30,
     );

      if(croppedImage!= null){
        setState(() {
          imageFile = CroppedFile as File?;
        });
      }

    }

    void showPhotoOptions(){
      showDialog(context: context, builder: (context){
       return AlertDialog(title: Text("Upload Profile Picture"),
       content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: (){
              Navigator.pop(context);
              selectImage(ImageSource.gallery);
            },
            leading: Icon(Icons.photo_album_outlined),
            title: Text("Select from gallary"),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              selectImage(ImageSource.camera);
            },
            leading: Icon(Icons.camera_alt_outlined),
            title: Text("Take a photo"),
          ),
        ],
       ),
       );
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(245,34, 149, 242),
        title: Text("Complete Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: SafeArea(child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            SizedBox(height: 40,),
                  CupertinoButton(
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      showPhotoOptions();
                    },
                    child: CircleAvatar(
                      backgroundImage: (imageFile != null)? FileImage(imageFile!): null,
                      radius: 60,
                      backgroundColor: Color.fromARGB(245,34, 149, 242),
                      child: (imageFile== null)? Icon(Icons.person, size: 60,color: Colors.white,):null,
                    ),
                  ),
            SizedBox(height: 40,),
            TextField(decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              labelText: "Full Name",
            ),),
            SizedBox(height: 40,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(200,60), backgroundColor: Color.fromARGB(245,34, 149, 242),),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
              return HomePage();
            }));
                }, child: Text("Submit", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),))
          ],
        ),
      )),
    );
  }
}