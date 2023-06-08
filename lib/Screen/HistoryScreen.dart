import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u_philosophy/Common/Globals.dart';
import 'package:u_philosophy/Common/SQLiteHelper.dart';
import 'package:u_philosophy/Common/Util.dart';
import 'package:u_philosophy/Model/Note.dart';
import 'package:u_philosophy/Widget/CommonWidget.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key, required this.updateNoteAfter});

  final Function updateNoteAfter;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final sortTypeList = ["최신순", "시간순"];
  final textController = TextEditingController();
  String sortName = "최신순";

  bool isEditingContent = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton2(
              isExpanded: true,
              value: sortName,
              items: sortTypeList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  sortName = value.toString();
                  if (sortName == "최신순") {
                    noteList.sort((b, a) => a.date.compareTo(b.date));
                  } else {
                    noteList.sort((a, b) => a.date.compareTo(b.date));
                  }
                });
              },
              buttonStyleData: const ButtonStyleData(
                  height: 50,
                  width: 80,
                  padding: EdgeInsets.symmetric(vertical: 10)),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
            ),
            noteList.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Center(
                      child: Text(
                        "작성 내역이 없습니다.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: noteList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var note = noteList[index];
                      return InkWell(
                        child: HistoryListItem(
                          note: note,
                        ),
                        onTap: () {
                          showContentBottomSheet(note);
                        },
                      );
                    })
          ],
        ),
      ),
    );
  }

  void showContentBottomSheet(Note note) {
    textController.text = note.content;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            return Scaffold(
              body: SizedBox(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        note.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: isEditingContent
                          ? TextField(
                              controller: textController,
                              decoration: const InputDecoration(
                                labelText: '내용을 입력해주세요.',
                                border: InputBorder.none,
                              ),
                            )
                          : Text(note.content),
                    )),
                    const Divider(
                      height: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: Platform.isIOS ? 25 : 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            DateFormat.yMd().format(DateTime.parse(note.date)),
                            style: const TextStyle(color: Colors.grey),
                          )),
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              bottomState(() {
                                isEditingContent = !isEditingContent;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 1,
                                      color:
                                          themeNotifier.value == ThemeMode.light
                                              ? Colors.black
                                              : Colors.white)),
                              child: Text(isEditingContent ? '수정취소' : '수정하기'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!isEditingContent) {
                                Navigator.pop(context);
                                return;
                              }

                              if (textController.text.isEmpty) {
                                Utils().showSnackBar(context, "답변을 입력해주세요.");
                                return;
                              }

                              note.content = textController.text;
                              SQLiteHelper.updateNote(note).whenComplete(() {
                                widget.updateNoteAfter();
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: themeNotifier.value == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white),
                              child: Text(
                                isEditingContent ? '저장' : '닫기',
                                style: TextStyle(
                                    color:
                                        themeNotifier.value == ThemeMode.light
                                            ? Colors.white
                                            : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            );
          },
        );
      },
    );
  }
}
