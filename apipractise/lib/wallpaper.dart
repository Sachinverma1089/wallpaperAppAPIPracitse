import 'dart:convert';
import 'dart:io';

import 'package:apipractise/fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallpaperWidget extends StatefulWidget {
  const WallpaperWidget({super.key});

  @override
  State<WallpaperWidget> createState() => _WallpaperWidgetState();
}

class _WallpaperWidgetState extends State<WallpaperWidget> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'uCVUzlmXKlGsGbK5xh57SKZzK8lGksbknlKlAUnRQtim4ehJyG4ua2Vz'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'uCVUzlmXKlGsGbK5xh57SKZzK8lGksbknlKlAUnRQtim4ehJyG4ua2Vz'
    }).then(
      (value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images.addAll(result['photos']);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Wallpapers"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(
                                      imageurl: images[index]['src']['large2x'],
                                    )));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Image.network(
                          images[index]['src']['tiny'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: Text(
                  "Load More",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
