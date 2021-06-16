
import 'package:flora_sense/models/Flower.dart';
import 'package:flora_sense/models/ImageUpdate.dart';
import 'package:flora_sense/pages/imageListItemUpdate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import '../database/dataHandler.dart';
import 'dart:io';


import 'colorListItem.dart';
import 'imageListItem.dart';

class UpdateFlower extends StatefulWidget
{
  late Flower flower;

  UpdateFlower({Key? key,required this.flower}) : super(key: key);

  @override
  _UpdateFlowerState createState() => _UpdateFlowerState(flower);
}

class _UpdateFlowerState extends State<UpdateFlower>
{

  late Flower flower;

  List<ImageUpdate> files = [];
  late ImageUpdate previewImageFile;
  List<String> colorList = [];
  bool isLoading = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController sNameController = new TextEditingController();
  TextEditingController familyController = new TextEditingController();
  TextEditingController genusController = new TextEditingController();
  TextEditingController short_descController = new TextEditingController();
  TextEditingController usage_descController = new TextEditingController();


  _UpdateFlowerState(this.flower);


  @override
  void initState() {

    previewImageFile = new ImageUpdate(new File(''),flower.preview);

    files.add(new ImageUpdate(new File(''), ''));

    for(String link in flower.images)
    {
        files.add(new ImageUpdate(new File(''),link));
    }


    colorList.add('');
    colorList.addAll(flower.colors);

    nameController.text = flower.name;
    sNameController.text = flower.scientific_name;
    familyController.text = flower.family;
    genusController.text = flower.genus;
    short_descController.text = flower.short_desc;
    usage_descController.text = flower.usage;

    super.initState();



  }


  @override
  Widget build(BuildContext context)
  {
    return getView();
  }
  Widget getView()
  {
    if(!isLoading)
    {
      return Scaffold(
          body: getForm()
      );
    }
    return getLoadingScreen();

  }
  Widget getLoadingScreen()
  {
    return Scaffold(

        body: Center(child: CircularProgressIndicator())
    );
  }
  Widget getForm()
  {
    return SingleChildScrollView(
      child: Container(

        margin: EdgeInsets.only(left: 30,right: 30),
        child: Column(

          children: [


            SizedBox(height: 100,),

            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextField(

                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: 'Flower name',
                    hintStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
              ),
            ),

            SizedBox(height: 10,),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextField(

                controller: sNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: 'Scientific name',
                    hintStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
              ),
            ),

            SizedBox(height: 10,),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextField(

                controller: familyController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: 'Family',
                    hintStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
              ),
            ),

            SizedBox(height: 10,),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextField(

                controller: genusController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: 'Genus',
                    hintStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView.builder(
                  key: Key(colorList.length.toString()),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: colorList.length,
                  itemBuilder: (context,position){


                    return ColorItem(colorList[position],(result) => addColor(result));

                  }),
            ),


            SizedBox(height: 10,),



            Container(
                width: MediaQuery.of(context).size.width,
                child: getPreviewWidget()

            ),
            SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView.builder(
                  key: Key(files.length.toString()),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (context,position){

                    return ImageItemUpdate(files[position],position,openImagePicker,(pos) => removeFile(pos));

                  }),
            ),


            SizedBox(height: 20,),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: TextField(

                controller:short_descController,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: 'Short description',
                    hintStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
              ),
            ),


            SizedBox(height: 10,),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: TextField(

                controller: usage_descController,
                minLines: 10,
                maxLines: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    hintText: 'Usage',
                    hintStyle: TextStyle(fontWeight: FontWeight.w500)
                ),
              ),
            ),

            SizedBox(height: 10,),
            GestureDetector(
              onTap: () => {addFlower()},
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(

                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),

                ),
                child: Center(child: Text('Add Flower',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor),)),


              ),
            ),
            SizedBox(height: 50,)

          ],

        ),
      ),
    );
  }
  addColor(String color)
  {

    print('called fun $color');

    setState(() {
      colorList.add(color);
    });
  }
  void openImagePicker() async
  {
    final picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {

      if(pickedFile != null && pickedFile.path != null)
      {

        ImageUpdate iu = new ImageUpdate(new File(pickedFile.path), '');
        files.add(iu);

        // DBHandler().uploadImage(context, new File(pickedFile.path)).then((value) => {
        //
        //   DBHandler().insertDocument(value)
        // });
      }

    });

  }
  Widget getPreviewWidget()
  {
    if(previewImageFile.file.path.isNotEmpty)
    {
      return GestureDetector(child: Image.file(previewImageFile.file,width: MediaQuery.of(context).size.width,height: 120,fit: BoxFit.cover,),onTap: () => {openImagePickerForPreview()});
    }


    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]
      ),
      child: GestureDetector(
        child: Image.network(previewImageFile.link,
          width: 20,
          height: 20,
        ),
        onTap: () => {openImagePickerForPreview()},
      ),
    );

  }
  void openImagePickerForPreview() async
  {
    final picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {

      if(pickedFile != null)
      {
        print('came here1' + pickedFile.path);
        previewImageFile = new ImageUpdate(new File(pickedFile.path),'');
      }

    });

  }
  void removeFile(int position)
  {
    setState(() {

      files.removeAt(position);

    });
  }
  addFlower()
  {

    String name = nameController.text;
    String sname = sNameController.text;
    String family = familyController.text;
    String genus = genusController.text;
    String short_desc = short_descController.text;
    String usage = usage_descController.text;


    if(name.isEmpty)
    {
      showToasts('Please fill the flower name');
      return;
    }
    if(sname.isEmpty)
    {
      showToasts('Please fill the scientific name');
      return;
    }
    if(family.isEmpty)
    {
      showToasts('Please fill the family');
      return;
    }
    if(genus.isEmpty)
    {
      showToasts('Please fill the genus');
      return;
    }

    if(colorList.length <= 1)
    {
      showToasts('Please pick at least one color');
      return;
    }

    if(previewImageFile.file.path.isEmpty && previewImageFile.link.isEmpty)
    {
      showToasts('Please pick a preview Image');
      return;
    }
    if(files.length <= 1)
    {
      showToasts('Please pick at least one image');
      return;
    }
    if(short_desc.isEmpty)
    {
      showToasts('Please fill the short description');
      return;
    }
    if(usage.isEmpty)
    {
      showToasts('Please fill the usages');
      return;
    }



    setState(() {
      isLoading = true;
    });



    DBHandler().updateFlower(flower.id,previewImageFile, files, colorList, name, sname, family, genus, short_desc, usage).then((bool isSuccess) => {

      finalize(isSuccess)

    });


  }
  finalize(bool value)
  {
    if(value)
    {
      setState(()
      {
        isLoading = false;
      });

      //close update screen
      Navigator.pop(context,true);
      //close view more screen
      Navigator.pop(context,true);

    }
  }
  showToasts(String message)
  {
    showToast(message,context:context);
  }


}
