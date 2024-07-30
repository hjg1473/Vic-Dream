import 'package:block_english/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegStudentScreen extends ConsumerStatefulWidget {
  const RegStudentScreen({super.key});

  @override
  ConsumerState<RegStudentScreen> createState() => _StudState();
}

class _StudState extends ConsumerState<RegStudentScreen> {
  String name = '';
  String username = '';
  String password = '';
  String password2 = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  String nameError = '';
  String usernameError = '';
  String passwordError = '';
  String password2Error = '';

  onRegisterPressed() async {
    bool onError = false;

    name = nameController.text;
    username = usernameController.text;
    password = passwordController.text;
    password2 = password2Controller.text;

    if (name == '') {
      setState(() {
        nameError = '이름을 입력해주세요';
      });
      onError = true;
    }

    if (username == '') {
      setState(() {
        usernameError = '전화번호를 입력해주세요';
      });
      onError = true;
    }

    if (password == '') {
      setState(() {
        passwordError = '비밀번호를 입력해주세요';
      });
      onError = true;
    }

    if (password != password2) {
      setState(() {
        password2Error = '비밀번호가 일치하지 않습니다';
      });
      onError = true;
    }

    if (onError) {
      return;
    }

    final result = await ref
        .watch(authServiceProvider)
        .postAuthRegister(name, username, password, 1, 'student');

    result.fold((failure) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('가입 다시해'),
          ),
        );
      }
    }, (regResponseModel) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login_screen',
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text(
                        '돌아가기',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.minPositive, 40),
                        backgroundColor: Colors.grey[700],
                      ),
                    ),
                    const Spacer(flex: 4),
                    Column(
                      children: [
                        const Text(
                          '학습자 회원가입',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '이름과 전화번호를 알맞게 입력해주세요',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 3),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.minPositive, 40),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        '이메일 회원가입',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      width: (MediaQuery.of(context).size.width - 180) / 2,
                      labelText: '이름',
                      hintText: '이름을 입력해주세요',
                      controller: nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Zㄱ-ㅎ가-힣]')),
                      ],
                      errorMessage: nameError,
                    ),
                    CustomTextField(
                      width: (MediaQuery.of(context).size.width - 180) / 2,
                      labelText: '전화번호',
                      hintText: '전화번호를 입력해주세요',
                      controller: usernameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      errorMessage: usernameError,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      width: (MediaQuery.of(context).size.width - 180) / 2,
                      labelText: '비밀번호',
                      hintText: '비밀번호를 입력해주세요',
                      controller: passwordController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                      ],
                      errorMessage: passwordError,
                      obscureText: true,
                    ),
                    CustomTextField(
                      width: (MediaQuery.of(context).size.width - 180) / 2,
                      labelText: '비밀번호 확인',
                      hintText: '비밀번호를 다시 입력해주세요',
                      controller: password2Controller,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                      ],
                      errorMessage: password2Error,
                      obscureText: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: onRegisterPressed,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(330, 50),
                    backgroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final double width;
  final double height;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String errorMessage;
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.width = 300,
    this.height = 70,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.inputFormatters,
    this.errorMessage = '',
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(labelText),
                errorMessage != ''
                    ? Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            errorMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
            TextField(
              inputFormatters: inputFormatters,
              obscureText: obscureText,
              controller: controller,
              cursorHeight: 20,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: hintText,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
