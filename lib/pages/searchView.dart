import 'package:flora_sense/database/LocalData.dart';
import 'package:flora_sense/models/Flower.dart';
import 'package:flora_sense/pages/viewMorePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'ListTile.dart';
import '../database/dataHandler.dart';
import 'insertFlower.dart';



class Dashboard extends StatefulWidget
{
  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard>
{

  List<Flower> flowerList = [];
  List<Flower> tempFlowerList = [];
  bool isLoading = true;
  TextEditingController searchTextController = new TextEditingController();

  Widget insertFlowerWidget = Text('');



  @override
  void initState(){

    super.initState();
    loadData();

  }
  loadData()
  {
    setLoading(true);


    DBHandler().getData(context).then((List<Flower> list) => {
      setData(list)
    });
  }
  setData(List<Flower> list)
  {
    setState(() {
      flowerList = list;
      tempFlowerList = flowerList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context)
  {
      return getView();
  }
  Widget getView()
  {
      if(isLoading)
      {
          return getLoadingScreen();
      }
      return getList();
  }
  Widget getLoadingScreen()
  {
    return Scaffold(

        body: Center(child: CircularProgressIndicator())
    );
  }
  Widget getList()
  {
    Widget w = Scaffold(


      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            )),
        child: Container(


            margin: EdgeInsets.symmetric(horizontal: 30),

            child: Column(
              children: [
                SizedBox(height: 80,),

                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(const Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 3),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          onSubmitted: (value) => search(),
                          maxLines: 1,
                          controller: searchTextController,

                          decoration: InputDecoration(
                              border: InputBorder.none,

                              hintText: 'Search flowers',
                              hintStyle: TextStyle(fontWeight: FontWeight.w500)
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 0,
                          child: GestureDetector(
                            child: Container(
                                width: 25,
                                height: 25,
                                child: Image.asset('assets/images/search_icon.png')

                            ),
                            onTap: () => {search()},
                          )
                      )
                    ],
                  ),
                ),

                SizedBox(height: 10,),

               Expanded(
                   child:  ListView.builder(
                     shrinkWrap: true,
                     itemCount: flowerList.length,
                     itemBuilder: (context,position) {

                       return TileItem(flowerList[position],(flower) => clickedViewMore(flower),(flower) => deleteFlower(flower));
                     },
                   ),
               ),


                insertFlowerWidget

              ],
            )
        ),
      ),

    );

    getViewBasedOnLoginState();

    return w;
  }
  getViewBasedOnLoginState() async
  {
    LocalData.isLogin().then((b) => {

      if(b)
      {
        setInsertFlowerWidget()
      }


    });

  }

  setInsertFlowerWidget()
  {

    setState(() {

      insertFlowerWidget = Container(
          margin: EdgeInsets.only(top: 20,bottom: 20,left: 0,right: 0),
          child: GestureDetector(
              child: Image.asset('assets/images/add.png', width: 55,),
              onTap: () => openInsertPage()

          )
      );

    });

  }
  void openInsertPage() async
  {
      bool value = await Navigator.push(context, MaterialPageRoute(builder: (context) => InsertView()));
      if(value)
      {
        loadData();
        showToast('Successfully inserted the flower!',context:context);
      }
  }
  void search()
  {
    String keyword = searchTextController.text;
    filterFlowerList(keyword);
  }
  void filterFlowerList(String keyword)
  {
      List<Flower> list = [];
      for(Flower flower in tempFlowerList)
      {
          if(flower.name.toLowerCase().startsWith(keyword.toLowerCase()))
          {
              list.add(flower);
          }
      }

      if(list.isEmpty)
      {
        showToast('No match found!',context:context);
        list = tempFlowerList;
      }


      setState(() {
        flowerList = list;
      });
  }
  clickedViewMore(Flower flower) async
  {
      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMore(flower: flower,)));
      if(value)loadData();
  }
  deleteFlower(Flower flower)
  {
    setLoading(true);
    setState(() {



    });

      DBHandler().deleteFlower(flower).then((value) => {

        if(value)
          showToast('deleted successfully!',context:context),
        setLoading(false),
        loadData()

      });
  }
  setLoading(bool b)
  {
    setState(() {
      isLoading = b;
    });
  }
}
