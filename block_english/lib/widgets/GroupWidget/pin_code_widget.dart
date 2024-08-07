import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinCodeWidget extends ConsumerStatefulWidget {
  const PinCodeWidget({
    super.key,
    required this.onButtonClicked,
    required this.pinCode,
    required this.elapsed,
  });
  final VoidCallback onButtonClicked;
  final String pinCode;
  final Duration elapsed;

  @override
  ConsumerState<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends ConsumerState<PinCodeWidget>
    with SingleTickerProviderStateMixin {
  String _formatDuration() {
    final seconds = (180 - widget.elapsed.inSeconds) % 60;
    final minutes = (180 - widget.elapsed.inSeconds) ~/ 60;

    var returnString = '';

    if (minutes != 0) {
      returnString += '$minutes분';
    }

    if (seconds != 0) {
      if (returnString.isNotEmpty) {
        returnString += ' ';
      }
      returnString += '$seconds초';
    }

    if (seconds == 0 && minutes == 0) {
      returnString = '핀 번호가 만료되었습니다. 다시 생성해주세요';
    }

    return returnString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0).r,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 0),
          ),
        ],
        color: Colors.white,
      ),
      width: 320.r,
      height: 176.r,
      child: Column(
        children: [
          SizedBox(
            width: 288.r,
            height: 36.r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '모니터링 학습자 추가 핀코드',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '학습자는 학습자 추가 핀코드를 입력해주세요',
                  style: TextStyle(
                    color: const Color(0xFFC2C2C2),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 288.r,
            height: 100.r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (String pin in widget.pinCode.split(''))
                      PinBlock(pin: pin)
                  ],
                ),
                Text(
                  _formatDuration(),
                  style: TextStyle(
                    color: const Color(0xFFC2C2C2),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: widget.onButtonClicked,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 65, 65, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
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

class PinBlock extends StatelessWidget {
  const PinBlock({super.key, required this.pin});

  final String pin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2).r,
      child: Container(
        alignment: Alignment.center,
        width: 28.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(4).r,
        ),
        child: Text(
          pin,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
