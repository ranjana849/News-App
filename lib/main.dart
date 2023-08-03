import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import 'model/newsmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<NewsModel> articles;

  @override
  void initState() {
    super.initState();
   articles = getNewsModel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body:FutureBuilder<NewsModel>(
        future: articles,
        builder: (_,snpshot){
          if(snpshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);

            } else if (snpshot.connectionState==ConnectionState.done){
              if(snpshot.hasData){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(

                  itemCount: snpshot.data!.articles!.length,
                      itemBuilder: (ctx,index){
                        return ListTile(
                        leading:Text('${index+1}'),
                        title: Text(snpshot.data!.articles![index].title!),
                          subtitle: Text(snpshot.data!.articles![index].description!),
                         trailing: Image.network(snpshot.data!.articles![index].urlToImage!),

                        );
                      }),
                );
              }else if(snpshot.hasError){
                return Text(snpshot.error.toString());
              }else{
                return Container();
              }
          }else{
            return Container();}
        },
      )

    );
  }
  Future<NewsModel> getNewsModel() async {
    var myUrl='https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=f071dcaafcbe4e7c91a3b797eb0f8f86';
    var res =await http.get(Uri.parse(myUrl));

    print(res.statusCode);
    if(res.statusCode==200){
      print(res.body.toString());
    return  NewsModel.fromJson(jsonDecode(res.body.toString()));
    }else {
      return NewsModel();
    }
  }
}
