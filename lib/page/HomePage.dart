import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../entity/VideoEntity.dart';
import '../widget/VideoItem.dart';

class HomeController extends GetxController {
  var keyword = "";
  var page = 1;
  var limit = 30;
  var videoItems = <VideoItem>[].obs;
  final dio = Dio();
  final TextEditingController _controller = TextEditingController();

  void getVideos() async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
    };
    if (keyword == "") {
      EasyLoading.showInfo("请输入关键字");
      return;
    }
    var url = "http://api.pingcc.cn/video/search/title/$keyword/$page/$limit";
    print("url: $url");
    EasyLoading.show(status: 'loading...');
    final response = await dio.get(url);
    EasyLoading.dismiss();
    final videos = VideoEntity.fromJson(response.data);
    print("length: ${videos.data?.length}");
    if (videos.data == null) {
      print("空");
      EasyLoading.showInfo("没有更多了");
    }
    if (page == 1) videoItems.clear();
    videos.data?.forEach((element) {
      videoItems.add(VideoItem(data: element));
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(context) {
    final HomeController controller = Get.put(HomeController());
    var size = MediaQuery.of(context).size;
    var count = 3 * size.width ~/ size.height + 1;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 24, 26, 1.0),
      body: Row(
        children: [
          Container(
            color: const Color.fromRGBO(30, 32, 34, 1.0),
            width: 50,
            height: double.infinity,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:
                            Container(
                              height: 40,
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.text,
                                controller: controller._controller,
                                onSubmitted: (e) {
                                  controller.page = 1;
                                  controller.getVideos();
                                },
                                onChanged: (e) {
                                  controller.keyword = e;
                                },
                                style: const TextStyle(
                                  color:
                                  Color.fromRGBO(208, 208, 208, 0.8), // 设置输入文本颜色
                                ),
                                decoration: InputDecoration(
                                  /// 输入框decoration属性
                                  isCollapsed: true,
                                  filled: true,
                                  fillColor: const Color.fromRGBO(33, 33, 33, 0.7),
                                  // 设置背景颜色
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      // 处理suffixIcon点击事件
                                      controller._controller.clear();
                                      controller.keyword = "";
                                    },
                                    child: const Icon(Icons.close),
                                  ),
                                  ///设置输入框可编辑时的边框样式
                                  enabledBorder: OutlineInputBorder(
                                    ///设置边框四个角的弧度
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(40)),
                                    ///用来配置边框的样式
                                    borderSide: BorderSide(
                                      ///设置边框的颜色
                                      color: Theme.of(context).primaryColor,
                                      ///设置边框的粗细r
                                      width: 2.0,
                                    ),
                                  ),
                                  ///用来配置输入框获取焦点时的颜色
                                  focusedBorder: OutlineInputBorder(
                                    ///设置边框四个角的弧度
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                    ///用来配置边框的样式
                                    borderSide: BorderSide(
                                      ///设置边框的颜色
                                      color: Theme.of(context).primaryColor,
                                      ///设置边框的粗细
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          controller.page = 1;
                          controller.getVideos();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(30, 32, 34, 1.0)), // 设置背景颜色
                          foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor), // 设置文字颜色
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            "搜索",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => controller.videoItems.isNotEmpty
                        ? EasyRefresh(
                            header: const PhoenixHeader(
                                skyColor: Color.fromRGBO(23, 24, 26, 1.0)),
                            footer: const MaterialFooter(),
                            onRefresh: () async {
                              controller.page = 1;
                              controller.getVideos();
                              return IndicatorResult.success;
                            },
                            onLoad: () async {
                              controller.page++;
                              controller.getVideos();
                            },
                            child: Obx(
                              () => GridView.count(
                                // physics: const BouncingScrollPhysics(),
                                crossAxisCount: count,
                                childAspectRatio: 0.7,
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                children: controller.videoItems,
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("空"),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
