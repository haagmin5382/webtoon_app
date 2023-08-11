import 'package:flutter/material.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;
  const Webtoon(
      {super.key, required this.title, required this.thumb, required this.id});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 250,
        clipBehavior: Clip.hardEdge,
        // 모서리가 둥글게 안되는 이유는 clipBehavior를 설정안해서 그렇다
        // clipBehavior는 자식의 부모 영역 침범을 제어하는 방법이다.
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
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
      const SizedBox(height: 10),
      Text(
        title,
        style: const TextStyle(
          fontSize: 22,
        ),
      )
    ]);
  }
}
