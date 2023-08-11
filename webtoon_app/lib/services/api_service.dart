import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon_app/models/webtoon_detail_model.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';
import 'package:webtoon_app/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
  // api요청을 하기 위해서 웹에서 fetch나 axios를 사용하는 것처럼 http 모듈을 사용해주자!

  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    // 데이터가 올 때까지 잠깐 멈춰야될 때가 있을 때 사용한다.
    // await으로 future가 완료될 때까지 기다린다.
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      // 텍스트로 응답된 body를 JSON으로 디코딩해준다.
      // dynamic으로 반환값이 나와서 type지정해주는게 좋음
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
        // print(webtoon);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);

      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  Future<List<WebtoonEpisodeModel>> getEpisodesById(String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        final content = WebtoonEpisodeModel.fromJson(episode);
        episodesInstances.add(content);
      }

      return episodesInstances;
    }
    throw Error();
  }
}
