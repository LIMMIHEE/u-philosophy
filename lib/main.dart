import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_philosophy/Common/Prefs.dart';
import 'package:u_philosophy/Common/SQLiteHelper.dart';
import 'package:u_philosophy/Screen/HistoryScreen.dart';
import 'package:u_philosophy/Screen/SettingScreen.dart';
import 'package:u_philosophy/Screen/WriteScreen.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'Common/Globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  await SQLiteHelper.getDatabase;
  await SQLiteHelper.loadNotes().then((value) {
    noteList = value;
    noteList.sort((b, a) => a.date.compareTo(b.date));
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    setThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, child) {
          return MaterialApp(
            theme:
                ThemeData(primaryColor: Colors.white, fontFamily: 'Pretendard'),
            themeMode: currentMode,
            darkTheme: ThemeData.dark(),
            home: Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    FutureBuilder(
                        future: SQLiteHelper.loadNotes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              noteList = snapshot.requireData;
                              noteList.sort((b, a) => a.date.compareTo(b.date));
                              return TabBarView(
                                controller: tabController,
                                children: [
                                  WriteScreen(
                                      questions: questionList,
                                      insertNoteAfter: setStateAction),
                                  HistoryScreen(
                                      updateNoteAfter: setStateAction),
                                  SettingScreen(
                                      updateSettingAfter: setStateAction)
                                ],
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 46, left: 24, right: 24),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius:
                                    0.0, // shadow direction: bottom right
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(56)),
                        child: TabBar(
                          indicatorColor: Colors.grey,
                          tabs: const [
                            Tab(
                              text: "작성",
                            ),
                            Tab(
                              text: "기록",
                            ),
                            Tab(
                              text: "설정",
                            ),
                          ],
                          controller: tabController,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          indicator: RectangularIndicator(
                            bottomLeftRadius: 100,
                            bottomRightRadius: 100,
                            topLeftRadius: 100,
                            topRightRadius: 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void setStateAction() {
    setState(() {});
  }

  void setThemeMode() {
    var darkmodeOn = prefs.getBool(Prefs().DARKMODE) ?? false;
    themeNotifier.value = darkmodeOn ? ThemeMode.dark : ThemeMode.light;
  }
}
