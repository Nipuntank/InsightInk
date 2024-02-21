import 'package:flutter/material.dart';
import 'package:news_app/models/show_category.dart';
import 'package:news_app/services/show_category_news.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Added import statement for CachedNetworkImage
import 'package:news_app/pages/article.dart';

class CategoryNews extends StatefulWidget {
  CategoryNews({super.key, required this.name});

  String name;

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews
        .getCategory(widget.name.toLowerCase()); // Corrected method name
    categories = showCategoryNews.categories; // Corrected list name
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ShowCategory(
                    Image: categories[index].urlToImage!,
                    desc: categories[index].description!,
                    title: categories[index].title!,
                    url: categories[index].url!,
                  );
                },
              ),
            ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  ShowCategory(
      {super.key,
      required this.Image,
      required this.desc,
      required this.title,
      required this.url});
  String Image, desc, title, url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: Image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              maxLines: 3,
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
