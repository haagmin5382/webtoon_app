import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon_app/models/webtoon_detail_model.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';
import 'package:webtoon_app/services/api_service.dart';
import 'package:webtoon_app/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen(
      {super.key, required this.title, required this.thumb, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon = ApiService().getToonById(widget.id);
  late Future<List<WebtoonEpisodeModel>> episodes =
      ApiService().getEpisodesById(widget.id);
  late SharedPreferences prefs;
  bool isLiked = false;
  // constructor에서 widget이 참조될 수 없기 때문에 사용할 수 없다.
  // 그래서 나중에 define할 거라고 적어주어야 한다. => late
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance(); // 저장소에 커넥션이 생김
    final likedToons = prefs.getStringList("likedToons");

    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        // 사용자가 지금 보고 있는 webtoon의 ID가 likedToons 안에 있는지 확인한다
        // 있다면 사용자가 웹툰에 좋아요를 누른 적 이 있다는 것이다.
        setState(() {
          isLiked = true;
        }); // setState를 해줘야 상태에 맞는 UI를 그려준다.
      }
    } else {
      prefs.setStringList("likedToons", []);
      // likedToons 없을 때 key, value 세팅
      // likedToons는 리스트로 오기 때문에 빈배열로 세팅한다.
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  onHeartTap() async {
    // initState 실행된 이후라 initPrefs도 실행되었기 때문에 likedToons는 빈배열이라도 만들어졌다.
    final likedToons = prefs.getStringList("likedToons");
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id); // 이미 좋아요 눌러져있다면 likedToons배열에서 삭제
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList("likedToons", likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Text(
            widget
                .title, // statefulWidget으로 바꾸는 순간 tilte로는 못찾는 이유는 별개의 클래스로 분류되기 때문이다.
            // widget은 부모한테 받는다는 의미 그래서 wiget.title로 접근할 수 있다.
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: onHeartTap,
              icon: isLiked
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline_outlined))
        ],
      ),
      body: SingleChildScrollView(
        // SingleChildScrollView는 오버플로우를 방지하고 스크롤하게 해준다.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,

                      clipBehavior: Clip.hardEdge,
                      // 모서리가 둥글게 안되는 이유는 clipBehavior를 설정안해서 그렇다
                      // clipBehavior는 자식의 부모 영역 침범을 제어하는 방법이다.
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                offset: const Offset(5, 5),
                                color: Colors.black.withOpacity(0.7))
                          ]),
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (var episode in snapshot.data!)
                            Episode(episode: episode, webtoonId: widget.id)
                        ],
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
