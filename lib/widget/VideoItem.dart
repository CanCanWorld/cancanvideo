import 'package:cancanvideo/route/Routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entity/VideoEntity.dart';

class VideoItem extends StatelessWidget {
  VideoItem({super.key, required this.data});

  final Data data;
  var offset = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(30, 32, 34, 1.0),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              // 阴影的颜色
              offset: Offset(offset.toDouble(), offset.toDouble()),
              // 阴影与容器的距离
              blurRadius: 6.0,
              // 高斯的标准偏差与盒子的形状卷积。
              spreadRadius: 0.0, // 在应用模糊之前，框应该膨胀的量。
            )
          ],
        ),
        child: MouseRegion(
          onEnter: (event) {
            // 当鼠标进入区域时触发
            offset += 6;
          },
          onExit: (event) {
            // 当鼠标离开区域时触发
            offset -= 6;
          },
          child: InkWell(
            hoverColor: Color.fromRGBO(44, 44, 44, 0),
            onTap: () {
              // 这里添加点击事件的处理逻辑
              print('被点击了！');
              Get.toNamed(Routes.SearchResultPage, arguments: data.videoId);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      data.cover.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    data.title.toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(208, 208, 208, 1)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
