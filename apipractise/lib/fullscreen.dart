import 'package:apipractise/wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String? imageurl;
  const FullScreen({Key? key, this.imageurl}) : super(key: key);
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    int location = WallpaperManager
        .BOTH_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageurl!);
    final bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Image.network(widget.imageurl!),
            )),
            Container(
              child: InkWell(
                onTap: () {
                  setWallpaper();
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "Set Wallpaper",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
