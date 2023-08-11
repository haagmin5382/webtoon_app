import 'package:flutter/material.dart';
import 'package:webtoon_app/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;
  const Webtoon(
      {super.key, required this.title, required this.thumb, required this.id});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              // MaterialPageRoute는 애니메이션 효과로 사용자가 다른 화면으로 간다고 느끼게 만든다.
              builder: (context) =>
                  DetailScreen(title: title, thumb: thumb, id: id),
              // fullscreenDialog: true // false면 flutter가 해당 화면이 card라고 인식
            ));
        // fullscreenDialog 바닥에서 이미지가 나오고 아이콘이 바뀜

        // route는 DetailScreen 같은 StatelessWidget을 애니메이션 효과로 감싸서 스크린처럼 보이도록 하겠다는 것
      },
      child: Column(children: [
        Hero(
          tag: id,
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
              thumb,
              headers: const {
                "User-Agent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
          ),
        )
      ]),
    );
  }
}
