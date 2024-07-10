import 'dart:ui';
import 'package:block_english/models/super_info_response_model.dart';
import 'package:block_english/services/super_service.dart';
import 'package:block_english/utils/colors.dart';
import 'package:block_english/utils/constants.dart';
import 'package:block_english/widgets/image_card_button.dart';
import 'package:block_english/widgets/no_image_card_button.dart';
import 'package:block_english/widgets/profile_button.dart';
import 'package:block_english/widgets/profile_card_widget.dart';
import 'package:block_english/widgets/round_corner_route_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SuperMainScreen extends StatefulWidget {
  const SuperMainScreen({super.key});

  @override
  State<SuperMainScreen> createState() => _SuperMainScreenState();
}

class _SuperMainScreenState extends State<SuperMainScreen> {
  final storage = const FlutterSecureStorage();
  String name = '';
  getProfileInfo() async {
    try {
      SuperInfoResponseModel superInfoResponseModel =
          await SuperService.getInfo();

      await storage.write(key: "name", value: superInfoResponseModel.name);
      setState(() {
        name = superInfoResponseModel.name;
      });
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("계정 정보를 불러올 수 없습니다.\n$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getProfileInfo();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Block English',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/setting_screen');
            },
          ),
          bottom: const TabBar(tabs: [
            Tab(
              text: '학생 관리',
            ),
            Tab(
              text: '게임 생성',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "프로필",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  name == ''
                      ? Container(
                          height: 80,
                          //width: 330,
                          decoration: BoxDecoration(
                            color: lightSurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black54,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: LinearProgressIndicator(),
                          ))
                      : ProfileCard(
                          name: name,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.black54,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '학생들에게 표시되는 이름이에요',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "그룹 관리",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ProfileButton(
                            name: "3학년 1반",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ProfileButton(
                            name: "2학년 1반",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ProfileButton(
                            name: "2학년 2반",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ProfileButton(
                            name: "그룹 추가",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "게임 방 만들기",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundCornerRouteButton(
                    text: "게임 생성",
                    routeName: '/super_game_setting_screen',
                    width: 330,
                    height: 50,
                    type: ButtonType.filled,
                    radius: 10,
                    bold: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "문제 세트 관리",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ImageCard(name: "3반 문제 세트"),
                          SizedBox(
                            height: 15,
                          ),
                          NoImageCard(name: "1반 문제 세트"),
                          SizedBox(
                            height: 15,
                          ),
                          NoImageCard(name: "2반 문제 세트"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundCornerRouteButton(
                    text: "문제 세트 추가",
                    routeName: '/super_game_screen',
                    width: 330,
                    height: 50,
                    type: ButtonType.outlined,
                    radius: 10,
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
