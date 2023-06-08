import 'package:flutter/material.dart';
import 'package:u_philosophy/Common/Globals.dart';
import 'package:u_philosophy/Common/Prefs.dart';
import 'package:u_philosophy/Common/SQLiteHelper.dart';
import 'package:u_philosophy/Common/Util.dart';
import 'package:u_philosophy/Model/Note.dart';
import 'package:u_philosophy/Widget/CommonWidget.dart';

class WriteScreen extends StatefulWidget {
  WriteScreen(
      {super.key, required this.questions, required this.insertNoteAfter});

  final List<String> questions;
  final Function insertNoteAfter;

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  late bool blurSwitch;

  @override
  void initState() {
    blurSwitch = prefs.getBool(Prefs().ANSWERBLUR) ?? false;
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getWriteAnswer().then((value) => controller.text = value);
    var isQuestionsEnd = widget.questions.length == noteList.length;
    var question = widget.questions.elementAt(noteList.length);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: isQuestionsEnd
            ? const Padding(
                padding: EdgeInsets.only(top: 300),
                child: Center(
                  child: Text(
                    "모든 질문에 답하셨습니다!",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      "${noteList.length + 1}",
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  BorderContainer(
                    bottomLeft: 0,
                    child: Text(
                      question,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: const BorderContainer(
                                bottomRight: 0,
                                isBlackContainer: true,
                                child: Text(
                                  "응답하기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            onTap: () {
                              if (controller.text.isEmpty) {
                                Utils().showSnackBar(context, "답변을 입력해주세요.");
                                return;
                              }

                              SQLiteHelper.insertNote(Note(
                                      date: DateTime.now().toString(),
                                      title: question,
                                      content: controller.text))
                                  .whenComplete(() {
                                setWriteAnswer("");
                                widget.insertNoteAfter();
                              });
                            },
                          ),
                          BorderContainer(
                            bottomRight: 0,
                            child: NonBorderTextField(
                                controller: controller,
                                focusNode: blurSwitch ? focusNode : null),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "작성 중인 텍스트는 저장됩니다.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ))
                ],
              ),
      ),
    );
  }
}
