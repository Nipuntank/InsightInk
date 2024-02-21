import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/pages/article.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';

class AllNews extends StatefulWidget {
  AllNews({super.key, required this.news});
  String news;

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getSlider();
    getNews();
  }

  getNews() async {
    setState(() {
      _loading = true;
    });

    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;

    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    setState(() {
      _loading = true;
    });

    Sliders slider = Sliders();
    await slider.getSlider();
    sliders = slider.sliders;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.news + "News",
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.news == "Breaking"
                    ? sliders.length
                    : articles.length,
                itemBuilder: (context, index) {
                  return AllNewsSection(
                    Image: widget.news == "Breaking"
                        ? sliders[index].urlToImage!
                        : articles[index].urlToImage!,
                    desc: widget.news == "Breaking"
                        ? sliders[index].description!
                        : articles[index].description!,
                    title: widget.news == "Breaking"
                        ? sliders[index].title!
                        : articles[index].title!,
                    url: widget.news == "Breaking"
                        ? sliders[index].url!
                        : articles[index].url!,
                  );
                },
              ),
            ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  AllNewsSection(
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
