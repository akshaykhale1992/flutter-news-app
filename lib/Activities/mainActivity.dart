import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../Model/Article.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  String _originalJson = '';
  loadJson() {
    http
        .read(
            'https://newsapi.org/v2/top-headlines?country=in&category=technology&pageSize=50&apiKey=<YOUR_API_KEY>')
        .then((responseJson) {
      print("Json Loaded, saving state");
      setState(() {
        _originalJson = responseJson;
      });
    });
  }

  Future<Widget> renderList() async {
    _originalJson = await http.read(
        'https://newsapi.org/v2/top-headlines?country=in&category=technology&pageSize=50&apiKey=<YOUR_API_KEY>');
    var responseJson = json.decode(_originalJson);
    var articles = responseJson['articles'] as List;
    var articlesList =
        articles.map<Article>((json) => Article.fromJson(json)).toList();
    return Column(children: createChildren(articlesList));
  }

  List<Widget> createChildren(articlesList) {
    return new List<Widget>.generate(
      articlesList.length,
      (int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: <Widget>[
              Text(
                articlesList[index].title,
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      articlesList[index].image ??
                          "http://via.placeholder.com/200x150",
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              Text(
                articlesList[index].description ??
                    (articlesList[index].content ?? ''),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {
                    String url = articlesList[index].url;
                    bool canVisit = await canLaunch(url);
                    if (canVisit) {
                      launch(url);
                    }
                  },
                  child: Text(
                    "Read More...",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                  autofocus: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todays News"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        children: <Widget>[
          Container(
            child: FutureBuilder<Widget>(
              future: renderList(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                }
                return Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {},
      ),
    );
  }
}
