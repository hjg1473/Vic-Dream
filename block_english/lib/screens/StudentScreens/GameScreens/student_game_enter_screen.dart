import 'package:block_english/screens/StudentScreens/GameScreens/student_game_waiting_screen.dart';
import 'package:block_english/services/game_service.dart';
import 'package:block_english/services/student_service.dart';
import 'package:block_english/utils/constants.dart';
import 'package:block_english/utils/status.dart';
import 'package:block_english/widgets/square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StudentGameEnterScreen extends ConsumerStatefulWidget {
  const StudentGameEnterScreen({
    super.key,
  });

  @override
  ConsumerState<StudentGameEnterScreen> createState() =>
      _StudentGameEnterScreenState();
}

class _StudentGameEnterScreenState
    extends ConsumerState<StudentGameEnterScreen> {
  final TextEditingController _pinCodeController = TextEditingController();
  String pincode = '';

  Future<dynamic> _showFailDialog(BuildContext context, String? detail) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.02).r,
        ),
        titlePadding: const EdgeInsets.fromLTRB(
          20,
          28,
          20,
          8,
        ).r,
        title: Center(
          child: Text(
            '입장 실패!',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20).r,
        content: Text(
          detail ?? '잠시 후 다시 시도해 주세요',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFA7A7A7),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          20,
          32,
          20,
          20,
        ).r,
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _pinCodeController.clear();
              });
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 13,
                horizontal: 97,
              ).r,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.02).r,
              ),
              backgroundColor: const Color(0xFF93E54C),
            ),
            child: Text(
              '다시 입력하기',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  onPressed() async {
    final response = await ref.watch(gameServiceProvider).postGameJoin(pincode);
    response.fold(
      (failure) {
        _showFailDialog(context, failure.detail);
      },
      (success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StudentGameWaitingScreen(
              pinCode: pincode,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: const Color(0xFFD1FCFE),
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1.sh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 1.sh - 68.r,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 32,
                        left: 64,
                        right: 64,
                      ).r,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                icon: SvgPicture.asset(
                                  'assets/buttons/round_back_button.svg',
                                  width: 48.r,
                                  height: 48.r,
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '게임 입장 PIN 코드 입력',
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '게임에 입장하기 위해 PIN 코드를 입력해 주세요',
                                      style: TextStyle(
                                        fontSize: 14.r,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0x88000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(flex: 8),
                          SizedBox(
                            width: 428.r,
                            child: PinCodeFields(
                              controller: _pinCodeController,
                              length: 6,
                              fieldWidth: 62.r,
                              fieldHeight: 76.r,
                              fieldBorderStyle: FieldBorderStyle.square,
                              borderRadius: BorderRadius.circular(11.2).r,
                              borderColor: Colors.white,
                              activeBorderColor: Colors.white,
                              fieldBackgroundColor: Colors.white,
                              activeBackgroundColor: Colors.white,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              animationDuration:
                                  const Duration(milliseconds: 100),
                              autoHideKeyboard: true,
                              textStyle: TextStyle(
                                fontSize: 42.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              onChange: (value) {
                                setState(() {
                                  pincode = value;
                                });
                              },
                              onComplete: (value) {
                                setState(() {
                                  pincode = value;
                                });
                              },
                            ),
                          ),
                          const Spacer(flex: 9),
                        ],
                      ),
                    ),
                  ),
                  SquareButton(
                    text: '게임 입장하기',
                    onPressed: pincode.length == 6 ? onPressed : null,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
