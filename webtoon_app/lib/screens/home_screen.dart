import 'package:flutter/material.dart';
import 'package:webtoon_app/models/webtoon_model.dart';
import 'package:webtoon_app/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  // API를 받아오기 때문에 const일 수가 없다.
  // const는 컴파일 전에 값을 알고 있다는 뜻

  final Future<List<WebtoonModel>> webtoons = ApiService().getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: const Text("오늘의 웹툰",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          // snapshot을 사용하면 Future의 상태를 알 수 있다.
          // snapshot을 통해서 변화를 알려준다.
          if (snapshot.hasData) {
            return Column(children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(child: makeList(snapshot)),
              // ListView에 제한된 높이를 주어야한다.
              // Expanded는 화면의 남는 공간을 차지하는 widget이다.
            ]);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ), // webtoons를 가져오는 api 요청을 기다려달라하자
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      // ListView는 scrollView도 자동적용된다.
      scrollDirection: Axis.horizontal, // 스크롤 방향을 수직이 아닌 수평으로 바꿔줌
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        // 이 인덱스로 어떤 아이템이 build되는지 알 수 있다.
        // ListView.builder는 사용자가 보고 있는 아이템만 build한다 (메모리를 절약하기위해)
        // print(index); // 스크롤을 넘기면 print가 계속 찍히는 것을 볼 수 있다. (메모리를 절약했다!)
        var webtoon = snapshot.data![index];
        return Column(children: [
          Container(
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
              webtoon.thumb,
              headers: const {
                "User-Agent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            webtoon.title,
            style: const TextStyle(
              fontSize: 22,
            ),
          )
        ]);
      },

      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
