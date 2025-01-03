import 'package:block_english/services/student_service.dart';
import 'package:block_english/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String info = '/';
const String season = '/season';
const String setting = '/setting';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required super.builder});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //return FadeTransition(opacity: animation, child: child);
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
              //.chain(CurveTween(curve: Curves.linear))
              .animate(animation),
      child: child,
    );
  }
}

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});
  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int currentPage = 1;
  Color? unselectedFontColor = const Color(0xFF76B73D);
  Color? selectedFontColor = const Color(0xFF58892E);
  Color? unselectedBackgroundColor = Colors.white;
  Color? selectedBackgroundColor = const Color(0xFFA9EA70);
  Color selectedBorderColor = const Color(0xFF8AD24C);

  onMenuPressed(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState!.pushReplacementNamed(route);
    });
  }

  onChangePasswordPressed() {
    Navigator.of(context).pushNamed('/user_change_password_screen');
  }

  onAddSuperPressed() async {
    final result = await Navigator.of(context)
        .pushNamed('/stud_add_super_screen', arguments: false);
    if (result == true) {
      setState(() {});
    }
  }

  onAccountPressed() {
    Navigator.of(context).pushNamed('/user_manage_account_screen');
  }

  waitForParentInfo() async {
    final response = await ref.watch(studentServiceProvider).getParentInfo();
    response.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${failure.statusCode}: ${failure.detail}'),
          ),
        );
      },
      (success) {
        ref.watch(statusProvider).setParent(success.name);
        setState(() {});
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    waitForParentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F7D4),
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 64,
                ).r,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SvgPicture.asset(
                    'assets/buttons/round_back_button.svg',
                    width: 48.r,
                    height: 48.r,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 64,
                  top: 189,
                ).r,
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: () {
                        if (currentPage != 1) {
                          onMenuPressed(info);
                          setState(() {
                            currentPage = 1;
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: Size(302.w, 44.r),
                        backgroundColor: currentPage == 1
                            ? selectedBackgroundColor
                            : unselectedBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ).r,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8).r,
                          side: currentPage == 1
                              ? BorderSide(
                                  color: selectedBorderColor,
                                )
                              : BorderSide.none,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        '내 정보',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: currentPage == 1
                              ? selectedFontColor
                              : unselectedFontColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.r),
                    FilledButton(
                      onPressed: () {
                        if (currentPage != 2) {
                          onMenuPressed(season);
                          setState(() {
                            currentPage = 2;
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: Size(302.r, 44.r),
                        backgroundColor: currentPage == 2
                            ? selectedBackgroundColor
                            : unselectedBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ).r,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8).r,
                          side: currentPage == 2
                              ? BorderSide(
                                  color: selectedBorderColor,
                                )
                              : BorderSide.none,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        '블록 잉글리시 보유 시즌 추가',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: currentPage == 2
                              ? selectedFontColor
                              : unselectedFontColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.r),
                    FilledButton(
                      onPressed: () {
                        if (currentPage != 3) {
                          onMenuPressed(setting);
                          setState(() {
                            currentPage = 3;
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: Size(302.r, 44.r),
                        backgroundColor: currentPage == 3
                            ? selectedBackgroundColor
                            : unselectedBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8).r,
                          side: currentPage == 3
                              ? BorderSide(
                                  color: selectedBorderColor,
                                )
                              : BorderSide.none,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        '환경 설정',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: currentPage == 3
                              ? selectedFontColor
                              : unselectedFontColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 64,
                ).r,
                child: SizedBox(
                  width: 302.r,
                  height: 156.r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/profile_photo.svg',
                            width: 72.r,
                            height: 72.r,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: 24.r,
                              height: 24.r,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  'assets/buttons/rounded_edit_button.svg',
                                  width: 24.r,
                                  height: 24.r,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 3),
                      Text(
                        ref.watch(statusProvider).name,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Text(
                        ref.watch(statusProvider).groupName ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(flex: 6),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 406.r,
                height: 1.sh,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  right: 64,
                ).r,
                child: SizedBox(
                  width: 302.r,
                  height: 319.r,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Navigator(
                      key: _navigatorKey,
                      initialRoute: info,
                      onGenerateRoute: (settings) {
                        return CustomRoute(
                          //fullscreenDialog: true,
                          builder: (context) {
                            switch (settings.name) {
                              case info:
                                return Info(
                                  onChangePasswordPressed:
                                      onChangePasswordPressed,
                                  onAddSuperPressed: onAddSuperPressed,
                                  onAccountPressed: onAccountPressed,
                                );
                              case season:
                                return const Season();
                              case setting:
                                return const Settings();
                              default:
                                return Info(
                                  onChangePasswordPressed:
                                      onChangePasswordPressed,
                                  onAddSuperPressed: onAddSuperPressed,
                                  onAccountPressed: onAccountPressed,
                                );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Info extends ConsumerStatefulWidget {
  final VoidCallback onChangePasswordPressed;
  final VoidCallback onAddSuperPressed;
  final VoidCallback onAccountPressed;

  const Info({
    super.key,
    required this.onChangePasswordPressed,
    required this.onAddSuperPressed,
    required this.onAccountPressed,
  });
  @override
  ConsumerState<Info> createState() => _InfoState();
}

class _InfoState extends ConsumerState<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정 정보',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(flex: 3),
          Container(
            width: 318.r,
            height: 58.r,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              color: const Color(0xFFE9FADB),
            ),
            child: SizedBox(
              width: 270.r,
              height: 44.r,
              child: Row(
                children: [
                  Text(
                    '아이디',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 16.r),
                  Text(
                    ref.watch(statusProvider).username,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  const Spacer(),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF93E54C),
                      minimumSize: Size(91.r, 26.r),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ).r,
                    ),
                    onPressed: widget.onChangePasswordPressed,
                    child: Text(
                      '비밀번호 변경',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '내 모니터링 관리자',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: widget.onAddSuperPressed,
                child: Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 3),
          Container(
            height: 110.r,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ).r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              color: const Color(0xFFE9FADB),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 41.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20).r,
                        color: const Color(0xFF93E54C),
                      ),
                      child: Text(
                        '그룹',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 21.r),
                    Text(
                      ref.watch(statusProvider).groupName ?? '연결된 그룹이 없어요',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 41.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20).r,
                        color: const Color(0xFF93E54C),
                      ),
                      child: Text(
                        '개인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 21.r),
                    Text(
                      ref.watch(statusProvider).parentName ?? '연결된 관리자가 없어요',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(flex: 5),
          Container(
            alignment: Alignment.center,
            height: 48.r,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              color: const Color(0xFFE9FADB),
            ),
            child: Row(
              children: [
                Text(
                  '계정 관리',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onAccountPressed,
                  child: Row(
                    children: [
                      Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.r),
                      Text(
                        '계정 탈퇴',
                        style: TextStyle(
                            fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
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

class Season extends ConsumerStatefulWidget {
  const Season({super.key});

  @override
  ConsumerState<Season> createState() => _SeasonState();
}

class _SeasonState extends ConsumerState<Season> {
  late List<int> availableSeason;
  late List<bool> selectedSeason = List.filled(2, false);

  onPressed() async {
    for (int i = 0; i < selectedSeason.length; i++) {
      if (selectedSeason[i] && !availableSeason.contains(i + 1)) {
        availableSeason.add(i + 1);
      }
    }

    final response = await ref
        .watch(studentServiceProvider)
        .putUpdateSeason(availableSeason);
    response.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${failure.statusCode}: ${failure.detail}'),
          ),
        );
      },
      (success) {
        ref.watch(statusProvider).setAvailableSeason(availableSeason);
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    availableSeason = ref.watch(statusProvider).availableSeason;
    for (int i = 0; i < availableSeason.length; i++) {
      selectedSeason[i] = true;
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '블록 잉글리시 보유 시즌 추가',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 30.r,
                height: 30.r,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    iconSize: 18.r,
                    backgroundColor: const Color(0xFF93E54C),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.r),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: availableSeason.contains(1)
                    ? null
                    : () {
                        setState(() {
                          selectedSeason[0] = !selectedSeason[0];
                        });
                      },
                icon: Image.asset(
                  selectedSeason[0]
                      ? 'assets/buttons/season_1_selected_small.png'
                      : 'assets/buttons/season_1_unselected_small.png',
                  width: 145.r,
                  height: 50.r,
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: availableSeason.contains(2)
                    ? null
                    : () {
                        setState(() {
                          selectedSeason[1] = !selectedSeason[1];
                        });
                      },
                icon: Image.asset(
                  selectedSeason[1]
                      ? 'assets/buttons/season_2_selected_small.png'
                      : 'assets/buttons/season_2_unselected_small.png',
                  width: 145.r,
                  height: 50.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '환경설정',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12.r),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: SvgPicture.asset(
              'assets/buttons/settings_notification_button.svg',
              width: 302.r,
              height: 48.r,
            ),
          ),
          SizedBox(height: 8.r),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: SvgPicture.asset(
              'assets/buttons/settings_app_version_button.svg',
              width: 302.r,
              height: 48.r,
            ),
          ),
          SizedBox(height: 8.r),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: SvgPicture.asset(
              'assets/buttons/settings_copyright_button.svg',
              width: 302.r,
              height: 48.r,
            ),
          ),
        ],
      ),
    );
  }
}
