import 'package:flutter/material.dart';
import 'package:flutterapp17/Utile/Utile.dart'as Utile;
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'dart:async';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String CityName;
  Future getChanges(BuildContext context)async{
    Map results= await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      })
    );
    
    setState(() {
      if(results != null && results.containsKey('info') ){
        CityName=results['info'];
        print(results['info'].toString());
      }
    });
  }
  void showApi()async{
    Map contant = await getWeather(Utile.appId,CityName);
    print(contant.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){getChanges(context);})
        ],
      ),
      body:Stack(
          children: <Widget>[
            Center(
              child:new Image.asset('assets/icon.png',width: 490.0,height: 1200.0,fit: BoxFit.fill),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 30.0, 0.0),
              child: Text("${CityName == null ? Utile.DefaultCity :CityName}",style: TextStyle(color: Colors.white,fontSize: 19.9),),
            ),
            Container(
              alignment: Alignment.center,
              child:new Image.asset('assets/icon2.png',width: 200,height: 200,),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(40.0,290.0, 0.0, 0.0),
              child: updateTempWidget(CityName)
            )

          ],
        ),
    );
  }
Future<Map> getWeather(String appId,String City)async{
    String apiUrl='http://api.openweathermap.org/data/2.5/weather?q=$City&appid=${Utile.appId}&units=imperial';
    http.Response response =await http.get(apiUrl);
    return json.decode(response.body);
}
Widget updateTempWidget(String City){
    return FutureBuilder(
        future:getWeather(Utile.appId,City == null ? Utile.DefaultCity : City),
        builder: (BuildContext context , AsyncSnapshot<Map>snapshot){
          if(snapshot.hasData){
            Map data=snapshot.data;
           return new Container(
              child: new ListView(
                children: <Widget>[
                  new ListTile(
                    title: Text("${data['main']['temp']}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.9,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text("${data['main']['humidity']}"),
                  )
                ],
              ),
            );
          }else{
            return new Container();
          }
        });
}

}
class ChangeCity extends StatefulWidget {
  @override
  _ChangeCityState createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
  var FristController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("changedCity"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Center(child:new Image.asset('assets/icon3.png',width: 490.0,height: 1200.0,fit: BoxFit.fill),),
          ListView(
            children: <Widget>[
              ListTile(title: TextField(
                controller: FristController,
                decoration: InputDecoration(
                    labelText: "Enter Your City",
                    hintText: "e.g rio"
                ),
              ),),
              ListTile(title: RaisedButton(
                child: Text("Get Weather"),
                onPressed: (){setState(() {
                  Navigator.pop(context,{'info':FristController.text});
                });},
                color: Colors.white70,
                textColor: Colors.redAccent,
              ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

