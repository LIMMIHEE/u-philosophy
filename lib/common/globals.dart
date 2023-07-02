import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_philosophy/common/prefs.dart';
import 'package:u_philosophy/model/note.dart';

late SharedPreferences prefs;
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
late List<Note> noteList;

const questionList = [
  "당신에게 제일 큰 가치를 가진 것은 무엇인가요?",
  "삶의 가장 큰 원동력이 무엇인가요?",
  "무엇을 추구하며 살아가고 있나요?",
  "자신만의 확고한 신념이 있다면?",
  "자신만의 규칙이 있다면?",
  "정의에 대해 어떻게 생각하시나요?",
  "돈이 양심을 좌우할 수 있을까요?",
  "악법도 법일까요?",
  "개인이 다수를 위해 희생되어도 될까요?",
  "하얀 거짓말은 잘못된 걸까요?",
  "법과 사회는 무엇을 위해 존재할까요?",
  "누군가를 미워하는 게 잘못된 행동일까요?",
  "당신에게 사랑이란 뭔가요?",
  "좋은 삶이란 무엇이라고 생각하시나요?",
  "행복한 삶이 좋은 삶일까요?",
  "재산이 많은 것이 행복한 삶일까요?",
  "삶은 무엇을 위해 존재할까요?",
  "목적 없는 삶이 나쁜 걸까요?",
  "사회 관계는 행복한 삶을 위해 필수적인걸까요?",
  "진정한 “나”는 무엇이라고 생각하시나요?",
  "타인과 함께 있을 적의 “나”와 혼자있는 “나”는 다를까요?",
  "자유란 무엇이라고 생각하시나요?",
  "가장 기억에 남는 일은 무엇인가요?",
  "기억이 삶의 주체가 될 수 있을까요?",
  "어른스럽지 못한 어른은 잘 못된 걸까요?",
  "당신에게 돈은 어느 정도의 중요도를 가지고 있나요?",
  "죽음은 나쁜 것일까요?",
  "모두가 공평하다면 삶은 행복할 수 있을까요?",
  "신은 존재할까요?",
  "운명이란 존재할까요?",
  "도피하는 것이 잘못된 것일까요?",
  "실패란 나쁜 것일까요?",
  "욕망이란 나쁜 것일까요?",
  "인간에 존재 의미란 뭐라고 생각하시나요?",
  "화를 내는 것이 나쁜 걸까요?",
  "아무것도 하지 않는 것이 잘못된 걸까요?",
  "느긋하게 사는 것이 잘못된 걸까요?",
];

void setWriteAnswer(String text) async {
  prefs.setString(Prefs().WRITINGANSWER, text);
}

Future<String> getWriteAnswer() async {
  return prefs.getString(Prefs().WRITINGANSWER) ?? "";
}
