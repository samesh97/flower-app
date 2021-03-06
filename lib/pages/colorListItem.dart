import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colorPicker.dart';

class ColorItem extends StatefulWidget
{
  late String color;
  Function colorAdd;
  Function colorDelete;
  int position;

  ColorItem(this.color,this.colorAdd,this.colorDelete,this.position);

  @override
  _ColorItemState createState() => _ColorItemState(color,colorAdd,colorDelete,position);
}

class _ColorItemState extends State<ColorItem>
{
  late String color;
  Function colorAdd;
  Function colorDelete;
  int position;

  _ColorItemState(this.color,this.colorAdd,this.colorDelete,this.position);

  @override
  Widget build(BuildContext context)
  {
    return getTile();
  }
  Widget getTile()
  {
      if(color.isEmpty)
      {
        return GestureDetector(child: Image.asset('assets/images/add.png',width: 40,height: 40,),onTap: () => {openColorPicker(context)},);
      }

      return GestureDetector(
      onLongPress: () => {colorDelete(position)},
        child: Container(
          margin: EdgeInsets.only(left: 15),
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
              color: fromHex(color),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black87, spreadRadius: 0.8)
              ]

          ),
        ),
      );
  }
  openColorPicker(BuildContext context) async
  {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ColorPickerF()));
    colorAdd(result);
  }
  static Color fromHex(String hexString)
  {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}
