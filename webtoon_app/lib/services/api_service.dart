import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";
  // api요청을 하기 위해서 웹에서 fetch나 axios를 사용하는 것처럼 http 모듈을 사용해주자!

  void getTodaysToons() async {
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    // 데이터가 올 때까지 잠깐 멈춰야될 때가 있을 때 사용한다.
    // await으로 future가 완료될 때까지 기다린다.
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }
}
