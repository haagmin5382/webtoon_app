import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';

class Episode extends StatelessWidget {
  const Episode({super.key, required this.episode, required this.webtoonId});
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  onButtonTap() async {
    print(webtoonId);
    print(episode.id);
    final url =
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}";
    await launchUrlString(url); // webView
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(5, 5),
                  color: Colors.black.withOpacity(0.5))
            ],
            color: Colors.green.shade400),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // 에피소드와 화살표 아이콘 사이에 공간을 둔다.
            children: [
              Text(
                episode.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
