import 'package:cancanvideo/widget/ChapterItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../page/VideoDetailController.dart';

class ChapterController extends GetxController {
  var isExpand = false.obs;
  var position = (-1).obs;
  var chapterItems = <ChapterItem>[].obs;
  var chapter = Get.find<VideoDetailController>().chapter;

  @override
  void onInit() {
    final VideoDetailController controller = Get.find();
    ever(controller.chapter, (_) {
      print("chapter发生了改变!!!${controller.chapter.value.updateTime}");
      var chapterList = controller.chapter.value.chapterList;
      if (chapterList != null) {
        print("1111");
        chapterItems.clear();
        for (var i = 0; i < chapterList.length; i++) {
          // 打印数组元素
          final element = chapterList[i];
          chapterItems.add(ChapterItem(
            title: element.title.toString(),
            position: i,
            onPressed: () {
              if (position.value == i) return;
              position.value = i;
              controller.path.value = element.chapterPath.toString();
            },
          ));
        }
      }
    });
    super.onInit();
  }
}

class ChapterWidget extends StatelessWidget {
  const ChapterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChapterController controller = Get.put(ChapterController());
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color.fromRGBO(43, 45, 48, 1.0),
      // 代表 B 布局
      height: double.infinity,
      // 举例设置高度
      width: double.infinity,
      child: Column(
        children: [
          Obx(() => Text(
                "${controller.chapter.value.title}",
                style: const TextStyle(
                    color: Color.fromRGBO(229, 231, 233, 1.0),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: Color.fromRGBO(229, 231, 233, 1.0),
                size: 12,
              ),
              Obx(
                () => Text(
                  "${controller.chapter.value.updateTime}",
                  style: const TextStyle(
                    color: Color.fromRGBO(229, 231, 233, 1.0),
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(() => Text(
                      "简介：${controller.chapter.value.descs?.replaceFirst("　　", "")}",
                      style: const TextStyle(
                        color: Color.fromRGBO(229, 231, 233, 1.0),
                        fontSize: 12,
                      ),
                      maxLines: controller.isExpand.value ? 99 : 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
              TextButton(
                onPressed: () {
                  controller.isExpand.value = !controller.isExpand.value;
                },
                child: Obx(() => Text(controller.isExpand.value ? "收起" : "展开")),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(35, 37, 39, 1.0),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "剧集",
                        style: TextStyle(
                          color: Color.fromRGBO(229, 231, 233, 1.0),
                          fontSize: 16,
                        ),
                      ),
                      Obx(
                        () => Text(
                          "（${controller.position.value + 1}/${controller.chapter.value.chapterList?.length}）",
                          style: const TextStyle(
                            color: Color.fromRGBO(229, 231, 233, 1.0),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ListView(
                          scrollDirection: Axis.vertical,
                          children: controller.chapterItems,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
