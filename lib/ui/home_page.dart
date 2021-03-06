import 'dart:convert';

import 'package:busca_gif/widget/custon_loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final AlwaysStoppedAnimation<Color> color;
  const HomePage({this.color});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  int _gifsPerPage = 24;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search == '')
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=CXY8vxhGo5C3ojIDlnBZI81Zb33KOBVa&limit=$_gifsPerPage&rating=g");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=CXY8vxhGo5C3ojIDlnBZI81Zb33KOBVa&q=$_search&limit=$_gifsPerPage&offset=$_offset&rating=g&lang=pt");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Container(
            child: Image.network(
              "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif",
              fit: BoxFit.cover,
            ),
            height: 25.0,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Pesquisar Gif",
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      final stroke = 5.0;
                      return CustonLoading(
                        widget: widget,
                        stroke: stroke,
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _GifGridWidget(snapshot: snapshot);
                  }
                },
              ),
            ),
          ],
        ),
      );
}

class _GifGridWidget extends StatelessWidget {
  const _GifGridWidget({@required this.snapshot});

  final AsyncSnapshot snapshot;

  @override
  build(_) => GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) => GestureDetector(
          child: Image.network(
            snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300.0,
            fit: BoxFit.cover,
          ),
        ),
      );
}
