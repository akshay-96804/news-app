import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_fetch/Database/article_data.dart';
import 'package:news_fetch/article.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryNews extends StatefulWidget {
  String category;
  CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  CategorieNews categorieNews = CategorieNews();
  List<ArticleModel> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    await categorieNews.fetchArticle(widget.category);
    articles = categorieNews.news;
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
          backgroundColor: Colors.transparent),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 750.0,
                      child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return NewssTile(
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

class NewssTile extends StatelessWidget {
  String imgUrl;
  String title;
  String desc;
  String articleUrl;
  NewssTile({this.desc, this.title, this.imgUrl, this.articleUrl});

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
