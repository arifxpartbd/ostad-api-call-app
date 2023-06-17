import 'dart:convert';

import 'package:apicallapp/models/page_model_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageDataModel pageDataModel = PageDataModel();
  bool _showProgressBar = false;

  Future<void> fetchData() async {
    _showProgressBar=true;
    setState(() {

    });
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_start=0&_limit=10'));
      if (response.statusCode == 200) {
        _showProgressBar = false;
        setState(() {

        });
        final responseData = json.decode(response.body);
        if (responseData is List) {
          _showProgressBar = false;
          setState(() {

          });
          // Handle the response as a list
          for (var item in responseData) {
            // Process each item in the list

            pageDataModel = PageDataModel.fromJson(item);
            setState(() {

            });
            print(item);
          }
        } else if (responseData is Map<String, dynamic>) {
          _showProgressBar = false;
          setState(() {

          });
          pageDataModel = PageDataModel.fromJson(responseData);
          setState(() {

          });
          // Handle the response as a map
          // Process the map data as needed
          print(responseData);
        } else {
          // Unexpected response type
          print('Unexpected response type: ${responseData.runtimeType}');
        }
      } else {
        _showProgressBar = false;
        setState(() {

        });
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      _showProgressBar = false;
      setState(() {

      });
      print('Error: $error');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          fetchData();
        },
        child: ListView.builder(
            itemCount: pageDataModel.id,
            itemBuilder: (context, index){
          return ListTile(
            title: Text(pageDataModel.title.toString()),
            subtitle: Text(pageDataModel.body.toString()),
            leading: Text(index.toString()),
          );
        }),
      ),
    );
  }
}
