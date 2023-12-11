import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ChapterWidget.dart';

class ChapterItemController extends GetxController {
  var isSelect = false.obs;

  @override
  void onInit() {
    final ChapterController controller = Get.find();
    ever(controller.position, (_) {
      print("position发生了改变!!!${controller.position}");
    });
    super.onInit();
  }
}

class ChapterItem extends StatelessWidget {
  const ChapterItem(
      {super.key,
      required this.title,
      required this.position,
      required this.onPressed});

  final String title;
  final int position;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ChapterController controller = Get.find();
    return Obx(
      () => TextButton(
        style: TextButton.styleFrom(
          backgroundColor: position == controller.position.value
              ? const Color.fromRGBO(67, 45, 57, 1.0)
              : const Color.fromRGBO(35, 37, 39, 1.0),
        ),
        onPressed: () {
          onPressed();
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: position == controller.position.value
                      ? Theme.of(context).primaryColor
                      : const Color.fromRGBO(229, 231, 233, 1.0),
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                position == controller.position.value ? "播放中" : "",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
