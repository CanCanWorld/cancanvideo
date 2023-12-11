import 'package:cancanvideo/entity/ChapterEntity.dart';
import 'package:cancanvideo/widget/ChapterWidget.dart';
import 'package:cancanvideo/widget/PlayerWidget.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class VideoDetailController extends GetxController {
  final dio = Dio();
  var chapter = Data().obs;
  var path = "".obs;
  var isSideOpen = true.obs;

  void getChapter(String vid) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
    };
    var url = "https://api.pingcc.cn/videoChapter/search/$vid";
    EasyLoading.show(status: 'loading...');
    final response = await dio.get(url);
    EasyLoading.dismiss();
    var chapterEntity = ChapterEntity.fromJson(response.data);
    if (chapterEntity.data != null) {
      chapter.value = chapterEntity.data!;
    }
  }

  @override
  void onInit() {
    getChapter(Get.arguments);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoDetailController controller = Get.put(VideoDetailController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.chapter.value.title ?? "加载中",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: VariableBox(context, controller),
    );
  }
}

Widget VariableBox(context, VideoDetailController controller) {
  var size = MediaQuery.of(context).size;
  if (size.width > size.height) {
    // 如果宽度大于高度，左右排列
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: Stack(
              children: <Widget>[
                // 底部红色
                const PlayerWidget(),
                // 顶部绿色
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(58, 58, 58, 0.35),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          controller.isSideOpen.value =
                              !controller.isSideOpen.value;
                        },
                        child: Center(
                          child: Obx(
                            () => Icon(
                              controller.isSideOpen.value
                                  ? Icons.arrow_right
                                  : Icons.arrow_left,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => controller.isSideOpen.value
            ? const SizedBox(
                width: 380,
                child: ChapterWidget(),
              )
            : const SizedBox()),
      ],
    );
  } else {
    // 如果宽度小于等于高度，上下排列
    return const Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: PlayerWidget(),
        ),
        Expanded(
          flex: 3,
          child: ChapterWidget(),
        ),
      ],
    );
  }
}
