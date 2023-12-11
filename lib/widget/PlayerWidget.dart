import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../page/VideoDetailController.dart';

class PlayerController extends GetxController {
  late final player = Player();
  late final controller = VideoController(player).obs;
  var path = Get.find<VideoDetailController>().path;

  @override
  void onInit() {
    ever(path, (_) {
      print("path发生了改变!!!${path.value}");
      player.open(Media(path.value));
    });
    super.onInit();
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.put(PlayerController());
    return Container(
      color: Colors.black,
      child: Obx(
        () => Center(
          child: controller.path.value == ""
              ? const Text(
                  "请选择剧集播放",
                  style: TextStyle(
                      color: Color.fromRGBO(229, 231, 233, 1.0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                  child: Video(controller: controller.controller.value),
                ),
        ),
      ),
    );
  }
}
