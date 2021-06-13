import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flora_sense/models/Flower.dart';
import 'package:flutter/cupertino.dart';


class DBHandler
{
   Future<List<Flower>> getData(BuildContext context) async
   {

     print('called');

     // Firebase.initializeApp();
     List<Flower> flowers = [];

     await FirebaseFirestore.instance
         .collection('flowers')
         .get()
         .then((QuerySnapshot querySnapshot)
         {
             querySnapshot.docs.forEach((doc)
             {
               String name = doc["name"];
               String preview = doc["preview"];
               String sname = doc["scientific_name"];
               List<dynamic> colors = doc["colors"];
               List<String> list = colors.map((s) => s as String).toList();

               String key = doc.id;


               Flower flower = new Flower(name, sname, list, preview);
               flower.id = key;
               flowers.add(flower);





             });
         });

     return flowers;

   }
}