class WebtoonEpisodeModel {
  final String title, thumb, id, rating, date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'],
        rating = json['rating'],
        date = json['date'];
  // Map<String, dynamic>은 TS로 따지면 key값이 String value값이 any이다.
  // named constructor라고 하고 이름이 있는 클래스 constructor
}
