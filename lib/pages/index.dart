import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nez/themes/color.dart';
import 'package:http/http.dart' as http;
import 'Viewer.dart';


//import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({ Key? key }) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List studies = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetcStudies();
  }

  fetcStudies()async{
    //var url = "http://localhost:8042/dicom-web/studies";
    var url = "https://server.dcmjs.org/dcm4chee-arc/aets/DCM4CHEE/rs/studies";
    //var url = "http://192.168.0.26:8042/studies";
    var response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if(response.statusCode == 200){
      var items = json.decode(response.body);
      print(items);
      setState(() {
        studies = items;
        print(studies);
      });
    }
    else{
      setState(() {
        studies = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dicom data"),
      ),
      body: getBody(),
    );
  }
  Widget getBody(){
    return ListView.builder(
      itemCount: studies.length,
      itemBuilder: (context, index){
      return getCard(index);
    });
  }
  Widget getCard(index){
    var studyDate = studies[index]["00080020"]["Value"][0];
    var patientsName = "Patient's name: ";
    var ime = studies[index]["00100010"]["Value"]?[0]["Alphabetic"];
    if(ime!=null){
      patientsName += ime;
    }
    var patientsId = studies[index]["00100020"]["Value"][0];
    var cs = studies[index]["00080061"]["Value"];
    String slike = "";
    for(var i=0; i<cs.length; i++){
      if(i != cs.length - 1)
        slike+=cs[i]+"/";
      else{
        slike += cs[i];
      }
    }
    var studyInstanceUID = studies[index]["0020000D"]["Value"][0];

    return GestureDetector(
      onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Viewer(studyInstanceUID.toString())));
    },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(60/2),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://images.unsplash.com/photo-1530497610245-94d3c16cda28?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80")
                    )
                  ),
                ),
                SizedBox(width: 20,),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Index: " + (index + 1).toString(), style: TextStyle(fontSize: 12)),
                    SizedBox(height: 10,),
                    Text("Study date: " + studyDate, style: TextStyle(fontSize: 12),),
                    SizedBox(height: 10,),
                    Text(patientsName, style: TextStyle(fontSize: 12),),
                    SizedBox(height: 10,),
                    Text("Patient's ID: " + patientsId, style: TextStyle(fontSize: 12),),
                    SizedBox(height: 10,),
                    Text("Images: " + slike, style: TextStyle(fontSize: 12),),
                    SizedBox(height: 10,),
                    Text("Study instance UID: \n" + studyInstanceUID, style: TextStyle(fontSize: 7),),
                    SizedBox(height: 10,),
                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}