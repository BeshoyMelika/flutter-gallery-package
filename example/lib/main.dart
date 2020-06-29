import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gallery Image Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Gallery Image Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final title;

  const MyHomePage({Key key, this.title}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Tap to show image"),
            GalleryImage(
              imageUrls: [
                "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
                "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
                "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
                "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
                "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg"
              ],
            ),
          ],
        ),
      ),
    );
  }
}
