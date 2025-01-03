// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum UserType {
  student,
  teacher,
  parent,
}

enum ButtonType {
  FILLED,
  OUTLINED,
}

const List<String> questionList = [
  "내가 좋아하는 색깔은?",
  "내가 가장 좋아하는 캐릭터는?",
  "제일 처음 한 게임 이름은?",
  "내가 좋아하는 나의 별명은?",
  "나의 보물 제 1호는?",
  "내가 제일 존경하는 인물은?"
];

const List<String> levelList = [
  "어순과 격",
  "부정문",
  "의문문",
];

enum StudentMode {
  PRIVATE,
  GROUP,
  NONE,
}

String modeToString(StudentMode mode) {
  switch (mode) {
    case StudentMode.PRIVATE:
      return 'solo';
    case StudentMode.GROUP:
      return 'group';
    case StudentMode.NONE:
      return 'none';
  }
}

enum Season {
  NONE,
  SEASON1,
}

int seasonToInt(Season season) {
  switch (season) {
    case Season.NONE:
      return 0;
    case Season.SEASON1:
      return 1;
  }
}

Season intToSeason(int intSeason) {
  switch (intSeason) {
    case 1:
      return Season.SEASON1;
    default:
      return Season.NONE;
  }
}

String seasonToString(Season season) {
  switch (season) {
    case Season.NONE:
      return 'none';
    case Season.SEASON1:
      return 'Season 1';
  }
}

String wrongToString(String wrong) {
  switch (wrong) {
    case 'wrong_word':
      return '단어';
    case 'wrong_block':
      return '블록';
    case 'wrong_punctuation':
      return '문장 부호';
    case 'wrong_order':
      return '단어 순서';
    case 'wrong_letter':
      return '대소문자';
    default:
      return ''; // Add a default return statement to handle unexpected input
  }
}

String wrongDetailToString(String wrong) {
  switch (wrong) {
    case 'wrong_word':
      return '올바른 단어를 사용하지 않았어요.';
    case 'wrong_block':
      return '단어를 알맞게 변경하지 못 했어요.';
    case 'wrong_punctuation':
      return '문장 부호를 잘못 넣었어요.';
    case 'wrong_order':
      return '단어 순서를 헷갈렸어요.';
    case 'wrong_letter':
      return '대소문자를 구분하지 않았어요.';
    default:
      return ''; // Add a default return statement to handle unexpected input
  }
}

enum BlockColor { skyblue, pink, green, yellow, purple, none }

BlockColor stringToBlockColor(String str) {
  switch (str) {
    case 'skyblue':
      return BlockColor.skyblue;
    case 'pink':
      return BlockColor.pink;
    case 'green':
      return BlockColor.green;
    case 'yellow':
      return BlockColor.yellow;
    case 'purple':
      return BlockColor.purple;
    default:
      return BlockColor.none;
  }
}

Color blockColorCToColor(BlockColor blockColor) {
  switch (blockColor) {
    case BlockColor.skyblue:
      return const Color(0xFF6CE7EA);
    case BlockColor.pink:
      return const Color(0xFFFF6699);
    case BlockColor.green:
      return const Color(0xFF93E54C);
    case BlockColor.yellow:
      return const Color(0xFFFFED48);
    case BlockColor.purple:
      return const Color(0xFFB13EFE);
    case BlockColor.none:
      return Colors.white;
  }
}

enum StudyMode {
  practice,
  expert,
  game,
  retry,
  none,
}

const String BASEURL = 'http://3.34.58.76';
const String BASEWSURL = 'ws://3.34.58.76/game/ws';
const String ACCESSTOKEN = 'accessToken';
const String REFRESHTOKEN = 'refreshToken';
const String TOKENVALIDATE = 'tokenValidate';
