import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart';
import '../common/prefs.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key, required this.updateSettingAfter});

  final Function updateSettingAfter;
  final Map<String, List<String>> settingMap = const {
    "화면설정": ["다크모드", "응답 블러 처리하기"]
  };

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool darkModeSwitch = false;
  bool blurSwitch = false;

  @override
  void initState() {
    darkModeSwitch = prefs.getBool(Prefs().DARKMODE) ?? false;
    blurSwitch = prefs.getBool(Prefs().ANSWERBLUR) ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.settingMap.length,
          itemBuilder: (context, index) {
            var key = widget.settingMap.keys.elementAt(index);
            var value = widget.settingMap.values.elementAt(index);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    key,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        spreadRadius: 0.0, // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = value.elementAt(index);
                        var isDarkMode = data == "다크모드";

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                data,
                                style: const TextStyle(
                                    color: Color(0xff393F44),
                                    fontWeight: FontWeight.w500),
                              )),
                              Transform.scale(
                                scale: 0.85,
                                child: CupertinoSwitch(
                                  activeColor: Colors.black,
                                  value:
                                      isDarkMode ? darkModeSwitch : blurSwitch,
                                  onChanged: (value) {
                                    if (isDarkMode) {
                                      themeNotifier.value =
                                          themeNotifier.value == ThemeMode.light
                                              ? ThemeMode.dark
                                              : ThemeMode.light;
                                    }
                                    setState(() {
                                      isDarkMode
                                          ? darkModeSwitch = value
                                          : blurSwitch = value;

                                      prefs.setBool(
                                          isDarkMode
                                              ? Prefs().DARKMODE
                                              : Prefs().ANSWERBLUR,
                                          value);
                                    });
                                    widget.updateSettingAfter();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: value.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider()),
                )
              ],
            );
          }),
    );
  }
}
