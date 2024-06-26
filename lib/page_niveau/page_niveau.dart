import 'package:akari_project/general/background.dart';
import 'package:akari_project/general/custom_app_bar.dart';
import 'package:akari_project/nav_bar/nav_bar.dart';
import 'package:akari_project/page_niveau/level.dart';
import 'package:akari_project/page_niveau/level_tile.dart';
import 'package:akari_project/general/themes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PageNiveau extends StatelessWidget {
  PageNiveau({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Hive.box('userBox').get("background");
    List<Level> level = [
      Level(size: Size.petit, icon: "🥉", color: MyTheme.getTheme(theme).petit),
      Level(size: Size.moyen, icon: "🥈", color: MyTheme.getTheme(theme).moyen),
      Level(size: Size.grand, icon: "🥇", color: MyTheme.getTheme(theme).grand)
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: ((bool didPop) async {
        if (didPop) {
          return;
        }
        AudioPlayer back = AudioPlayer();
        await back.setSourceAsset("music/back_sound.mp3");
        await back.resume();
        Navigator.pop(context);
      }),
      child: Scaffold(
        appBar: const CustomAppBar(),
        extendBody: true,
        bottomNavigationBar: const NavBar(
          selected: NavButton.central,
        ),
        body: Center(
          child: BackgroundCustom(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 170),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.rotate(
                      angle: -0.15,
                      child: const Text(
                        "Choisis ta partie !",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                        textAlign: TextAlign.center,
                      )),
                  LevelTile(
                    level: level[0],
                  ),
                  LevelTile(
                    level: level[1],
                  ),
                  LevelTile(
                    level: level[2],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
