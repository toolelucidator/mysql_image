import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllPersonData extends StatefulWidget {
  @override
  _AllPersonDataState createState() => _AllPersonDataState();
}

class _AllPersonDataState extends State<AllPersonData> {
  Future allPerson() async {
    var url = "http://192.168.1.24/image_upload_php_mysql/viewAll.php";
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    allPerson();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TestCode.com'),
        ),
        body: FutureBuilder(
            future: allPerson(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) => snapshot
                    .hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, index) => Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                              "http://192.168.1.24/image_upload_php_mysql/uploads/${snapshot.data![index]['image']}"),
                        ),
                        subtitle:
                            Center(child: Text(snapshot.data![index]['name'])),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
