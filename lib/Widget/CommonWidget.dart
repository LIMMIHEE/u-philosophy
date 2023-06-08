import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u_philosophy/Model/Note.dart';
import '../Common/Globals.dart';

class BorderContainer extends StatelessWidget {
  final double topRight;
  final double topLeft;
  final double bottomRight;
  final double bottomLeft;

  final Widget child;

  final bool isBlackContainer;

  const BorderContainer({
    this.topRight = 16,
    this.topLeft = 16,
    this.bottomRight = 16,
    this.bottomLeft = 16,
    this.isBlackContainer = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 325),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBlackContainer ? Colors.black87 : Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topRight),
            topLeft: Radius.circular(topLeft),
            bottomRight: Radius.circular(bottomRight),
            bottomLeft: Radius.circular(bottomLeft),
          ),
          border: Border.all(
            width: 1,
          ),
        ),
        child: child);
  }
}

class HistoryListItem extends StatelessWidget {
  const HistoryListItem({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      bottomRight: 0,
      topRight: 26,
      topLeft: 26,
      bottomLeft: 26,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    note.id < 10 ? '0${note.id}' : "${note.id}",
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat.Md().format(DateTime.parse(note.date)),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff9D9D9D)),
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xff494949)),
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class NonBorderTextField extends StatelessWidget {
  const NonBorderTextField(
      {super.key, required this.focusNode, required this.controller});

  final FocusNode? focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      focusNode: focusNode,
      controller: controller,
      textInputAction: TextInputAction.go,
      style: TextStyle(
        foreground: Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.black87
          ..maskFilter = MaskFilter.blur(BlurStyle.normal,
              (focusNode != null && !focusNode!.hasFocus) ? 4 : 0),
      ),
      decoration: const InputDecoration(
          hintStyle: TextStyle(fontSize: 14),
          hintText: '당신의 의견을 적어주세요.',
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero),
      onChanged: (text) {
        setWriteAnswer(text);
      },
    );
  }
}
