import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_fetch/Database/article_data.dart';
import 'package:news_fetch/Database/practice_data.dart';
import 'package:news_fetch/article.dart';
import 'package:news_fetch/screens/categoryNews.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategorieModel> newCategories;
  List<ArticleModel> articles = [];
  String myUrl;
  bool isLoading = true;
  ArticleNews articleNews = ArticleNews();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newCategories = displayCategories();
    fetchNews();
  }

  fetchNews() async {
    await articleNews.fetchArticle();
    articles = articleNews.myArticles;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              'News',
              style: TextStyle(color: Colors.greenAccent),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 60.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newCategories.length,
                          itemBuilder: (context, index) {
                            return CategoryNewz(
                                categoryName:
                                    newCategories[index].categorieName,
                                imgUrl: newCategories[index].imageAssetUrl);
                          }),
                    ),
                    Container(
                      height: 750.0,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return NewsTile(
                                desc: articles[index].description,
                                title: articles[index].title,
                                imgUrl: articles[index].urlToImage,
                                articleUrl: articles[index].articleUrl);
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryNewz extends StatelessWidget {
  String categoryName;
  String imgUrl;
  CategoryNewz({this.categoryName, this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CategoryNews(category: categoryName);
        }));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.0),
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(imgUrl,
                  height: 60.0, width: 120.0, fit: BoxFit.cover)),
          Container(
            width: 120.0,
            height: 60.0,
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            child: Text(
              categoryName,
              style: TextStyle(color: Colors.white),
            ),
          )
        ]),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  String imgUrl;
  String title;
  String desc;
  String articleUrl;
  NewsTile({this.desc, this.title, this.imgUrl, this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(articleUrl);
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                )),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            Text(desc)
          ],
        ),
      ),
    );
  }
}
