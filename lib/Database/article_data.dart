import 'dart:convert';

import '../article.dart';
import 'package:http/http.dart' as http;

class ArticleNews {
  String myUrl =
      'https://newsapi.org/v2/top-headlines?country=in&category=buisness&apiKey=a4af22c79e3d41bcb45a64c9123b070d';
  List<ArticleModel> myArticles = [];

  Future<void> fetchArticle() async {
    http.Response response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=a4af22c79e3d41bcb45a64c9123b070d');
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['description'] != null && element['urlToImage'] != null) {
          ArticleModel articleModel = ArticleModel(
              content: element['content'],
              dateTime: element['publishedAt'],
              description: element['description'],
              title: element['title'],
              urlToImage: element['urlToImage'],
              articleUrl: element['url']);
          myArticles.add(articleModel);
        }
      });
    }
  }
}

class CategorieNews {
  List<ArticleModel> news = [];

  Future<void> fetchArticle(String category) async {
    http.Response response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=a4af22c79e3d41bcb45a64c9123b070d');
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['description'] != null && element['urlToImage'] != null) {
          ArticleModel articleModel = ArticleModel(
              content: element['content'],
              dateTime: element['publishedAt'],
              description: element['description'],
              title: element['title'],
              urlToImage: element['urlToImage'],
              articleUrl: element['url']);
          news.add(articleModel);
        }
      });
    }
  }
}
